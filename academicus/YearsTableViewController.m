//
//  YearsTableViewController.m
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "YearsTableViewController.h"

@interface YearsTableViewController ()

@end

@implementation YearsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the view title to the qualification name
    self.title = self.qualification.name;
    
    // Initialise variable not in edit mode
    self.inSwipeDeleteMode = NO;
    
    // Add an edit button to the navigation bar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections
    // 1 for normal mode, 2 for edit mode to contain the add button
    return (self.isEditing && !self.inSwipeDeleteMode) ? 2 : 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in each section
    // If the add button is visible, return 1 otherwise return the number of data items
    if (self.isEditing && !self.inSwipeDeleteMode && section == 1) {
        return 1;
    } else {
        return [self.qualification.years count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check whether the current cell is the add new item cell
    BOOL isAddCell = (self.isEditing && !self.inSwipeDeleteMode && indexPath.section == 1);
    
    // Assign the correct identifier for this cell
    NSString *myIdentifier = (isAddCell) ? @"addCell" : @"yearCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    }
    
    // Set the content for each type of cell
    if (isAddCell) {
        cell.textLabel.text = @"Add new year";
    } else {
        Year *currentYear = (Year*) [self.qualification.years objectAtIndex:indexPath.row];
        cell.textLabel.text = currentYear.name;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing && !self.inSwipeDeleteMode) {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            // If the user clicks the add button, perform a segue to the add page
            [self performSegueWithIdentifier:@"addYear" sender:self];
            
        } else if (indexPath.section == 0) {
            // If the user clicks an item cell in edit mode, perform a segue to the edit page
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self performSegueWithIdentifier:@"editYear" sender:cell];
        }
        
    } else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"toSubjects" sender:cell];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


# pragma mark - Reordering Cells

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Prevent the add item cell from being reordered
    if (indexPath.section == 1) {
        return NO;
    } else {
        return YES;
    }
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source and the table view
        [self.qualification.years removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set the add or delete icons to the correct cells
    if (!self.inSwipeDeleteMode && indexPath.section == 1) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
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
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    } else {
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}


// This method is run only when the user swipes to delete a row
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set a flag variable and enable editing mode
    self.inSwipeDeleteMode = YES;
    [self setEditing:YES animated:YES];
}


// This method is run only when the user swipes to delete a row
- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable editing mode and reset the flag variable
    [self setEditing:NO animated:YES];
    self.inSwipeDeleteMode = NO;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addYear"]) {
        // If going to the new item page, get the view controller and assign the delegate to this class
        UINavigationController *navController = segue.destinationViewController;
        YearDetailTableViewController *controller = (YearDetailTableViewController*) navController.topViewController;
        controller.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"editYear"]) {
        // If going to the edit item page, also set the item to edit from the data array
        UINavigationController *navController = segue.destinationViewController;
        YearDetailTableViewController *controller = (YearDetailTableViewController*) navController.topViewController;
        controller.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.qualification.years[indexPath.row];
        
    }  else if ([segue.identifier isEqualToString:@"toSubjects"]) {
        // If going to the subjects view, get the view controller and pass the selected list of subjects
        SubjectsTableViewController *controller = (SubjectsTableViewController*) segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.year = self.qualification.years[indexPath.row];
    }
}


#pragma mark - YearDetailTableViewControllerDelegate

- (void)YearDetailTableViewController:(id)controller didFinishAddingYear:(Year *)year
{
    // Add the new item to the data array
    NSInteger newRowIndex = [self.qualification.years count];
    [self.qualification.years addObject:year];
    
    // Insert a new cell for the item into the table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // Dismiss the add item view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)YearDetailTableViewController:(id)controller didFinishEditingYear:(Year *)year
{
    // Find the cell for this item and update the contents
    NSInteger index = [self.qualification.years indexOfObject:year];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = year.name;
    
    // Dismiss the edit item view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)YearDetailTableViewControllerDidCancel:(id)controller
{
    // No action to take so dismiss the modal window
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
