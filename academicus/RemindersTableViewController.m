//
//  RemindersTableViewController.m
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "RemindersTableViewController.h"

@interface RemindersTableViewController ()

@end

@implementation RemindersTableViewController
{
    // Local instance variable for the fetched results controller
    NSFetchedResultsController *_fetchedResultsController;
}


// Custom getter for the fetched results controller
- (NSFetchedResultsController*)fetchedResultsController
{
    // Initialise the fetched results controller if nil
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // Get the objects from the managed object context
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AssessmentCriteria" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the sorting preference
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deadline" ascending:!self.isPast];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Set the predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat: (self.isPast ? PAST_PREDICATE : UPCOMING_PREDICATE), [NSDate date]];
        [fetchRequest setPredicate:predicate];
        
        // Create the fetched results controller
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Reminders"];
        
        // Assign this class as the delegate
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isPast = false;
    
    // Delete the cache to prevent inconsistencies in iOS7
    [NSFetchedResultsController deleteCacheWithName:@"Reminders"];
    
    // Retrieve the objects for this table view using CoreData
    [self performFetch];
    
    // Override the height of the table view header
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 44);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)performFetch
{
    // Fetch the data for the table view using CoreData
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        // Throw a custom error if the fetch fails
        COREDATA_ERROR(error);
        return;
    }
}


- (void)dealloc
{
    // Stop the fetched results controller from sending notifications if the view is deallocated
    _fetchedResultsController.delegate = nil;
}


- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl* segmentControl = (UISegmentedControl*) sender;
    NSInteger selectedSegment = segmentControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        self.isPast = false;
    } else {
        self.isPast = true;
    }
    
    // Delete the cache
    [NSFetchedResultsController deleteCacheWithName:@"Reminders"];
    _fetchedResultsController = nil;
    [self performFetch];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in each section
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Assign the correct identifier for this cell
    NSString *myIdentifier;
    if (self.isPast) {
        myIdentifier = @"pastCell";
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


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
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

    if (self.isPast) {
        UILabel *ratingLabel = (UILabel *)[cell viewWithTag:202];
        switch ([assessment.rating intValue]) {
            case 1: ratingLabel.text = @"★☆☆☆☆"; break;
            case 2: ratingLabel.text = @"★★☆☆☆"; break;
            case 3: ratingLabel.text = @"★★★☆☆"; break;
            case 4: ratingLabel.text = @"★★★★☆"; break;
            case 5: ratingLabel.text = @"★★★★★"; break;
            default: ratingLabel.text = @"No rating"; break;
        }
        UILabel *gradeLabel = (UILabel *)[cell viewWithTag:300];
        gradeLabel.text = (assessment.finalGrade) ? [NSString stringWithFormat: @"%d%%",[assessment.finalGrade intValue]] : @"?";
    } else {
        UILabel *daysRemainingLabel = (UILabel *)[cell viewWithTag:202];
        NSTimeInterval secondsBetween = [assessment.deadline timeIntervalSinceDate:[NSDate date]];
        
        UILabel *alarmIcon = (UILabel *)[cell viewWithTag:300];
        alarmIcon.hidden = (assessment.reminder != nil) ? NO : YES;

        int daysBetween = secondsBetween/86400;
        switch (daysBetween) {
            case 0: daysRemainingLabel.text = @"Due today"; break;
            case 1: daysRemainingLabel.text = @"Due tomorrow"; break;
            default: {
                if (daysBetween < 366) {
                    daysRemainingLabel.text = [NSString stringWithFormat: @"You have %i days remaining", daysBetween];
                } else {
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                    daysRemainingLabel.text = [NSString stringWithFormat: @"Due on %@", [dateFormatter stringFromDate:assessment.deadline]];  break;
                }
            }
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"visitGrade" sender:cell];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"visitGrade"]) {
        UINavigationController *navController = segue.destinationViewController;
        AssessmentGradeTableViewController *controller = (AssessmentGradeTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}


#pragma mark - AssessmentGradeTableViewControllerDelegate

- (void)AssessmentGradeTableViewControllerDidCancel:(AssessmentGradeTableViewController*)controller
{
    // No action to take so dismiss the modal window
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)AssessmentGradeTableViewController:(AssessmentGradeTableViewController*)controller didFinishEditingAssessment:(AssessmentCriteria*)assessment
{
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the edit item view
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
