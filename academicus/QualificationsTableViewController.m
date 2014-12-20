//
//  QualificationsTableViewController.m
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "QualificationsTableViewController.h"

@interface QualificationsTableViewController ()

@end

@implementation QualificationsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialise the data array
    self.qualifications = [[NSMutableArray alloc] init];
    
    // TEST DATA
    Qualification *q = [[Qualification alloc] init];
    q.name = @"A-Level";
    [self.qualifications addObject:q];
    
    Qualification *q2 = [[Qualification alloc] init];
    q2.name = @"Degree";
    [self.qualifications addObject:q2];
    
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
        return [self.qualifications count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check whether the current cell is the add new item cell
    BOOL isAddCell = (self.isEditing && !self.inSwipeDeleteMode && indexPath.section == 1);
    
    // Assign the correct identifier for this cell
    NSString *myIdentifier = (isAddCell) ? @"addCell" : @"qualificationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    }
    
    // Set the content for each type of cell
    if (isAddCell) {
       cell.textLabel.text = @"Add new qualification";
    } else {
        Qualification *currentQualification = (Qualification*) [self.qualifications objectAtIndex:indexPath.row];
        cell.textLabel.text = currentQualification.name;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the user clicks the add button, perform a segue to the add page, otherwise do nothing
    if (self.isEditing && indexPath.section == 1 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"addQualification" sender:self];
    }
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
        [self.qualifications removeObjectAtIndex:indexPath.row];
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
    if ([segue.identifier isEqualToString:@"addQualification"]) {
        UINavigationController *navController = segue.destinationViewController;
        AddQualificationTableViewController *controller = (AddQualificationTableViewController*) navController.topViewController;
        controller.delegate = self;
    }
}


#pragma mark - AddQualificationTableViewControllerDelegate

- (void)addQualificationTableViewController:(id)controller didFinishAddingQualification:(Qualification *)qualification
{
    NSInteger newRowIndex = [self.qualifications count];
    [self.qualifications addObject:qualification];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)addQualificationTableViewControllerDidCancel:(id)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
