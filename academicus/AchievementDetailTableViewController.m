//
//  AchievementDetailTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "AchievementDetailTableViewController.h"

@implementation AchievementDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Achievement";
        self.nameField.text = self.itemToEdit.name;
        self.dateAchieved = self.itemToEdit.dateAchieved;
        self.descriptionField.text = self.itemToEdit.information;
    } else {
        // If no item was passed through, create default date values
        self.dateAchieved = [NSDate date];
    }
    
    // Assign the stored dates to the labels on the view
    self.dateLabel.text = [self formatDate:self.dateAchieved];
    
    // Set the date picker visible flags to false
    self.datePickerVisible = NO;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Open the keyboard automatically when the view appears
    [self.nameField becomeFirstResponder];
}


- (IBAction)cancel
{
    // Delegate method when the cancel button is pressed
    [self.delegate achievementDetailTableViewControllerDidCancel:self];
}


- (BOOL) isEnteredDataValid
{
    //Check for the presence of a name
    if ([self.nameField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"You must provide a name" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    return true;
}


- (IBAction)done
{
    if (![self isEnteredDataValid]) {return;}
    
    if (self.itemToEdit != nil) {
        // If editing, update the item
        self.itemToEdit.name = self.nameField.text;
        self.itemToEdit.dateAchieved = self.dateAchieved;
        self.itemToEdit.information = self.descriptionField.text;
        
        [self.delegate achievementDetailTableViewController:self didFinishEditingAchievement:self.itemToEdit];
        
    } else {
        // If adding, create a new item
        Achievement *newAchievement = [NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:self.managedObjectContext];
        newAchievement.name = self.nameField.text;
        newAchievement.dateAchieved = self.dateAchieved;
        newAchievement.information = self.descriptionField.text;
        
        [self.delegate achievementDetailTableViewController:self didFinishAddingAchievement:newAchievement];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // When the name field is edited, hide any visible date pickers
    if (self.datePickerVisible) {
        [self hideDatePicker];
    }
}


- (NSString*)formatDate:(NSDate*)date
{
    // Helper method to quickly format date strings to be displayed in labels
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    return [formatter stringFromDate:date];
}


- (void)showDatePicker
{
    // Set the visible flag to true
    self.datePickerVisible = YES;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:1];
    
    // Insert a new row for the date picker and reload the label row
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    // Create the date picker cell and display it
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*) [datePickerCell viewWithTag:100];
    [datePicker setDate:self.dateAchieved animated:YES];
}


- (void)hideDatePicker
{
    // Set the visible flag to false
    self.datePickerVisible = NO;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:1];
    
    // Delete the date picker row and reload the label row
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


// Override this method to enable the date picker cell to be created
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the cell should be a date picker cell
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        NSString *identifier = @"datePickerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        // Create a new cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Add a date picker view to the cell
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
            datePicker.tag = 100;
            datePicker.datePickerMode = UIDatePickerModeDate;
            [cell.contentView addSubview:datePicker];
            
            // Set the action
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        
        return cell;
        
    } else {
        // If the cell is not a date picker cell, call the super method
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (void)dateChanged:(UIDatePicker*)datePicker
{
    // Update the variable and label when the date picker value changes
    self.dateAchieved = datePicker.date;
    self.dateLabel.text = [self formatDate:self.dateAchieved];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If the date picker is visible for this section, return 2 otherwise call the super method
    if (section == 1 && self.datePickerVisible) {
        return 2;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If this cell contains a cell picker, manually set the cell height to fit the picker
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 217.0f;
    }
    
    // Otherwise call the super method
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If this cell is a date label, enable selections so the user can click to show or hide the date picker
    if (indexPath.section == 1 && indexPath.row == 0) {
        return indexPath;
    }
    
    // Otherwise return nil to prevent cell selection
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Hide the keyboard if a cell was clicked on
    [self.nameField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    
    // If the cell is the start date label cell
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        // Toggle the visibility of the date picker cell
        if (!self.datePickerVisible) {
            [self showDatePicker];
        } else {
            [self hideDatePicker];
        }
    }
}


// This method is required to add dynamic cells to a table view containing static cells
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

@end
