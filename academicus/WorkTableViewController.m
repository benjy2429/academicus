//
//  WorkTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "WorkTableViewController.h"

@implementation WorkTableViewController {
    // Local instance variable for the fetched results controller
    NSFetchedResultsController *_fetchedResultsController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Delete the cache to prevent inconsistencies in iOS7
    [NSFetchedResultsController deleteCacheWithName:@"WorkExperiences"];
    
    // Retrieve the objects for this table view using CoreData
    [self performFetch];
    
    // Initialise variable not in edit mode
    self.inSwipeDeleteMode = NO;
    
    // Add an edit button to the navigation bar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Core Data

// Custom getter for the fetched results controller
- (NSFetchedResultsController*)fetchedResultsController {
    // Initialise the fetched results controller if nil
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // Get the objects from the managed object context
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkExperience" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the sorting preference
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:NO];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Create the fetched results controller
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"WorkExperiences"];
        
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections
    // 1 for normal mode, 2 for edit mode to contain the add button
    return (self.isEditing && !self.inSwipeDeleteMode) ? 2 : 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in each section
    // If the add button is visible, return 1 otherwise return the number of data items
    if (self.isEditing && !self.inSwipeDeleteMode && section == 1) {
        return 1;
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check whether the current cell is the add new item cell
    BOOL isAddCell = (self.isEditing && !self.inSwipeDeleteMode && indexPath.section == 1);
    
    // Assign the correct identifier for this cell
    NSString *myIdentifier = (isAddCell) ? @"addCell" : @"workExperienceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myIdentifier];
    }
    
    // Set the content for each type of cell
    if (isAddCell) {
        cell.textLabel.text = @"Add new work experience";
    } else {
        [self configureCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath {
    // Get the object for this cell and set the labels
    WorkExperience *work = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ at %@", work.jobTitle, work.companyName];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ to %@", [formatter stringFromDate:work.startDate], [formatter stringFromDate:work.endDate]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing && !self.inSwipeDeleteMode) {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            // If the user clicks the add button, perform a segue to the add page
            [self performSegueWithIdentifier:@"addWork" sender:self];
            
        } else if (indexPath.section == 0) {
            // If the user clicks an item cell in edit mode, perform a segue to the edit page
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self performSegueWithIdentifier:@"editWork" sender:cell];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


# pragma mark - Reordering Cells

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Set to nil to perform reordering manually
    self.fetchedResultsController.delegate = nil;
    
    // Copy the results into a mutable array
    NSMutableArray *orderedItems = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    
    // Move the reordered item in the array
    WorkExperience *work = [self.fetchedResultsController objectAtIndexPath:fromIndexPath];
    [orderedItems removeObject:work];
    [orderedItems insertObject:work atIndex:toIndexPath.row];
    
    // Iterate through the objects and update the display order to match the array order
    NSInteger i = [orderedItems count] - 1;
    for (NSManagedObject *item in orderedItems) {
        [item setValue:[NSNumber numberWithInteger:i] forKey:@"displayOrder"];
        i--;
    }
    
    // Save the objects back
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Reassign the fetched results controller delegate
    self.fetchedResultsController.delegate = self;
    
    // Perform another fetch to ensure the cache is up to date
    [self performFetch];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Prevent the add item cell from being reordered
    return (indexPath.section != 1);
}


//Prevent re-ordering below the add new. Will move as far as possible rather than returning to its starting position
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}


# pragma mark - Editing Cells

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        WorkExperience *work = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:work];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            COREDATA_ERROR(error);
            return;
        }
    }
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set the add or delete icons to the correct cells
    return (!self.inSwipeDeleteMode && indexPath.section == 1) ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    // If the user swiped, the add item button does not need to be added
    if (self.inSwipeDeleteMode) {
        return;
    }
    
    // Add or remove the add item section if entering or exiting edit mode
    if (editing) {
        [self.tableView beginUpdates];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } else {
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}


// This method is run only when the user swipes to delete a row
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set a flag variable and enable editing mode
    self.inSwipeDeleteMode = YES;
    [self setEditing:YES animated:YES];
}


// This method is run only when the user swipes to delete a row
- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // Disable editing mode and reset the flag variable
    // Due to a bug in iOS 8.1, this method is called twice and crashes the app so check if in editing mode first
    if (self.editing) {
        [self setEditing:NO animated:YES];
        self.inSwipeDeleteMode = NO;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addWork"]) {
        UINavigationController *navController = segue.destinationViewController;
        WorkDetailTableViewController *controller = (WorkDetailTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
        
    } else if ([segue.identifier isEqualToString:@"editWork"]) {
        UINavigationController *navController = segue.destinationViewController;
        WorkDetailTableViewController *controller = (WorkDetailTableViewController*) navController.topViewController;
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


#pragma mark - WorkDetailTableViewControllerDelegate

- (void)workDetailTableViewController:(id)controller didFinishAddingWork:(WorkExperience *)work {
    work.displayOrder = [NSNumber numberWithInteger:[[self.fetchedResultsController fetchedObjects] count]];
    work.portfolio = self.portfolio;
    
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the add item view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)workDetailTableViewController:(id)controller didFinishEditingWork:(WorkExperience *)work {
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the edit item view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)workDetailTableViewControllerDidCancel:(id)controller {
    // No action to take so dismiss the modal window
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

