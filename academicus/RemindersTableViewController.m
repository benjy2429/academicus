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
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deadline" ascending:[self.predicateString isEqualToString:UPCOMING_PREDICATE]];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Set the predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat: self.predicateString, [NSDate date]];
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
    
    self.predicateString = UPCOMING_PREDICATE;
    
    // Delete the cache to prevent inconsistencies in iOS7
    [NSFetchedResultsController deleteCacheWithName:@"Reminders"];
    
    // Retrieve the objects for this table view using CoreData
    [self performFetch];
    
    // Add an edit button to the navigation bar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        self.predicateString = UPCOMING_PREDICATE;
    } else {
        self.predicateString = PAST_PREDICATE;
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
    NSString *myIdentifier = @"reminderCell";
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
    
    cell.textLabel.text = assessment.name;
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
