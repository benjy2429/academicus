//
//  RemindersTableViewController.m
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "RemindersTableViewController.h"

@implementation RemindersTableViewController {
    // Local instance variable for the fetched results controller
    NSFetchedResultsController *_fetchedResultsController;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //Default is upcoming
    self.isPast = false;
    
    // Delete the cache to prevent inconsistencies in iOS7
    [NSFetchedResultsController deleteCacheWithName:@"Reminders"];

    // Retrieve the objects for this table view using CoreData
    [self performFetch];
    
    // Override the height of the table view header
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 44);
    
    //Swipe gestures that enable the user to swipe between the segmented controls
    UISwipeGestureRecognizer *leftGestureRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    [leftGestureRecogniser setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tableView addGestureRecognizer:leftGestureRecogniser];
    
    UISwipeGestureRecognizer *rightGestureRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    [rightGestureRecogniser setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:rightGestureRecogniser];
}


#pragma mark - Core Data

// Custom getter for the fetched results controller
- (NSFetchedResultsController*)fetchedResultsController {
    // Initialise the fetched results controller if nil
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // Get the objects from the managed object context
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AssessmentCriteria" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the sorting preference
        NSSortDescriptor *gradedSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hasGrade" ascending:YES];
        NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deadline" ascending:!self.isPast];
        [fetchRequest setSortDescriptors:@[gradedSortDescriptor, dateSortDescriptor]];
        
        // Set the predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat: (self.isPast ? PAST_PREDICATE : UPCOMING_PREDICATE), [NSDate date]];
        [fetchRequest setPredicate:predicate];
        
        // Create the fetched results controller
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"hasGrade" cacheName:@"Reminders"];
        
        // Assign this class as the delegate
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}


- (void)performFetch {
    // Fetch the data for the table view using CoreData
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        // Throw a custom error if the fetch fails
        COREDATA_ERROR(error);
        return;
    }
}


- (void)dealloc {
    // Stop the fetched results controller from sending notifications if the view is deallocated
    _fetchedResultsController.delegate = nil;
}


#pragma mark - Segmented Control

//Called when the segmented control is changed
- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl* segmentControl = (UISegmentedControl*) sender;
    NSInteger selectedSegment = segmentControl.selectedSegmentIndex;
    self.isPast = (selectedSegment != 0);
    
    // Delete the cache
    [NSFetchedResultsController deleteCacheWithName:@"Reminders"];
    _fetchedResultsController = nil;
    [self performFetch];
    [self.tableView reloadData];
}


//Called when a swipe gesture is recgonised
- (void)swiped:(UISwipeGestureRecognizer *)gestureRecogniser {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[self.tableView viewWithTag:700];
    
    //Set the segmented control based on the direction of swipe
    if (gestureRecogniser.direction == UISwipeGestureRecognizerDirectionRight) {
        segmentedControl.selectedSegmentIndex = 0;
    } else if (gestureRecogniser.direction == UISwipeGestureRecognizerDirectionLeft) {
        segmentedControl.selectedSegmentIndex = 1;
    }
    
    [self segmentSwitch:segmentedControl];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in each section
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Assign the correct identifier for this cell
    NSString *myIdentifier;
    if (self.isPast) {
        AssessmentCriteria *assessment = [self.fetchedResultsController objectAtIndexPath:indexPath];
        myIdentifier = ([assessment.hasGrade boolValue]) ? @"pastCellGraded" : @"pastCell";
    } else {
        myIdentifier = @"upcomingCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath {
    // Get the object for this cell and set the labels
    AssessmentCriteria *assessment = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //Subject Colour
    UIView *colourBar = (UIView *)[cell viewWithTag:100];
    colourBar.backgroundColor = assessment.subject.colour;
    
    //Date labels
    UILabel *dateDayLabel = (UILabel *)[cell viewWithTag:101];
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:assessment.deadline];
    NSInteger day = [dateComponents day];
    NSString* dayS = @(day).stringValue;
    dateDayLabel.text = dayS;
    UILabel *dateMonthLabel = (UILabel *)[cell viewWithTag:102];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateMonthLabel.text = [[dateFormatter shortMonthSymbols] objectAtIndex:([dateComponents month]-1)];
 
    //Assessment Information
    UILabel *assessmentNameLabel = (UILabel *)[cell viewWithTag:200];
    assessmentNameLabel.text = assessment.name;
    UILabel *subjectNameLabel = (UILabel *)[cell viewWithTag:201];
    subjectNameLabel.text = assessment.subject.name;

    //If a past event configure cell for a past deadline
    if (self.isPast) {
        //Add a rating
        UILabel *ratingLabel = (UILabel *)[cell viewWithTag:202];
        switch ([assessment.rating intValue]) {
            case 1: ratingLabel.text = @"★☆☆☆☆"; break;
            case 2: ratingLabel.text = @"★★☆☆☆"; break;
            case 3: ratingLabel.text = @"★★★☆☆"; break;
            case 4: ratingLabel.text = @"★★★★☆"; break;
            case 5: ratingLabel.text = @"★★★★★"; break;
            default: ratingLabel.text = @"No rating"; break;
        }
        //Show a grade if it has one
        if ([assessment.hasGrade boolValue]) {
            UILabel *gradeLabel = (UILabel *)[cell viewWithTag:300];
            gradeLabel.text = [NSString stringWithFormat: @"%d%%",[assessment.finalGrade intValue]];
        }
    } else {
        //Otherwise, configure cell for upcoming deadline
        
        //Add a days remaining label
        UILabel *daysRemainingLabel = (UILabel *)[cell viewWithTag:202];
        NSDate *currentDate = [NSDate date];
        NSDate *deadlineDate = assessment.deadline;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&currentDate interval:nil forDate:currentDate];
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&deadlineDate interval:nil forDate:deadlineDate];
        NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:currentDate toDate:deadlineDate options:0];
        
        //Add a few special cases depending on the difference between today and the deadline
        switch ([difference day]) {
            case 0: daysRemainingLabel.text = @"Due today"; break;
            case 1: daysRemainingLabel.text = @"Due tomorrow"; break;
            default: {
                if ([difference day] < 366) {
                    daysRemainingLabel.text = [NSString stringWithFormat: @"You have %i days remaining", (int)[difference day]];
                } else {
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                    daysRemainingLabel.text = [NSString stringWithFormat: @"Due on %@", [dateFormatter stringFromDate:assessment.deadline]];
                }
                break;
            }
        }
        
        //Add an alarm icon if a reminder is set
        UIImageView *alarmIcon = (UIImageView *)[cell viewWithTag:300];
        alarmIcon.hidden = (assessment.reminder == nil);
    }
}


//Returns a human friendly title for the section headers
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isPast) {
        BOOL hasGrade = [[[[self.fetchedResultsController sections] objectAtIndex:section] name] boolValue];
        return (hasGrade) ? @"Graded" : @"Awaiting Grade";
    }
    return nil;
}


//When any cell is selected, segue to the add grade page
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"visitGrade" sender:cell];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation
//Get the destination view controller and pass any objects needed
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"visitGrade"]) {
        UINavigationController *navController = segue.destinationViewController;
        AssessmentGradeTableViewController *controller = (AssessmentGradeTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    // Modify table rows depending on the action performed
    // (Called automatically by the NSFetchedResultsController)
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - AssessmentGradeTableViewControllerDelegate

- (void)AssessmentGradeTableViewControllerDidCancel:(AssessmentGradeTableViewController*)controller {
    // No action to take so dismiss the modal window
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)AssessmentGradeTableViewController:(AssessmentGradeTableViewController*)controller didFinishEditingAssessment:(AssessmentCriteria*)assessment {
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the edit item view
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // When the user scrolls down, keep the segmented control at the top of the screen under the navigation bar using a transform
    // Otherwise, scroll up as normal
    CGFloat offsetY = scrollView.contentOffset.y + 64.0f;
    UIView *headerView = [self.tableView viewWithTag:500];
    headerView.transform = CGAffineTransformMakeTranslation(0, MIN(offsetY,0));
}


@end

