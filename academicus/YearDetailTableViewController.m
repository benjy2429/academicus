//
//  YearDetailTableViewController.m
//  academicus
//
//  Created by Ben on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "YearDetailTableViewController.h"

@implementation YearDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Year";
        self.nameField.text = self.itemToEdit.name;
        self.startDate = self.itemToEdit.startDate;
        self.endDate = self.itemToEdit.endDate;
    } else {
        // If no item was passed through, create default date values
        self.startDate = [NSDate date];
        self.endDate = self.startDate;
    }
    
    // Assign the stored dates to the labels on the view
    self.startDateLabel.text = [self formatDate:self.startDate];
    self.endDateLabel.text = [self formatDate:self.endDate];
    
    // Set the date picker visible flags to false
    self.startDatePickerVisible = NO;
    self.endDatePickerVisible = NO;
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Open the keyboard automatically when the view appears
    [self.nameField becomeFirstResponder];
}


- (BOOL) isEnteredDataValid {
    //Check for the presence of a name
    if ([self.nameField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"You must provide a name" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the name length is less than 15
    if ([self.nameField.text length] > 15) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The name must be less than 15 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that start date is before end date
    if ([self.startDate timeIntervalSince1970] >= [self.endDate timeIntervalSince1970]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The start date must be before the end date" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    return true;
}


// Called when the done navigation bar button is pressed
- (IBAction)done {
    // Validate the input data
    if (![self isEnteredDataValid]) {return;}
    
    if (self.itemToEdit != nil) {
        // If editing, update the item
        self.itemToEdit.name = self.nameField.text;
        self.itemToEdit.startDate = self.startDate;
        self.itemToEdit.endDate = self.endDate;

        [self.delegate YearDetailTableViewController:self didFinishEditingYear:self.itemToEdit];
        
    } else {
        // If adding, create a new item
        Year *newYear = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:self.managedObjectContext];
        newYear.name = self.nameField.text;
        newYear.startDate = self.startDate;
        newYear.endDate = self.endDate;
        
        [self.delegate YearDetailTableViewController:self didFinishAddingYear:newYear];
    }
}


// Called when the cancel navigation bar button is pressed
- (IBAction)cancel {
    // Delegate method when the cancel button is pressed
    [self.delegate YearDetailTableViewControllerDidCancel:self];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // When the name field is edited, hide any visible date pickers
    if (self.startDatePickerVisible) {
        [self hideStartDatePicker];
    } else if (self.endDatePickerVisible) {
        [self hideEndDatePicker];
    }
}


#pragma mark - Date picker 

- (NSString*)formatDate:(NSDate*)date {
    // Helper method to quickly format date strings to be displayed in labels
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    return [formatter stringFromDate:date];
}


- (void)showStartDatePicker {
    // Set the visible flag to true
    self.startDatePickerVisible = YES;
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
    [datePicker setDate:self.startDate animated:YES];
}


- (void)showEndDatePicker {
    // Set the visible flag to true
    self.endDatePickerVisible = YES;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:2];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:2];
    
    // Insert a new row for the date picker and reload the label row
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    // Create the date picker cell and display it
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*) [datePickerCell viewWithTag:100];
    [datePicker setDate:self.endDate animated:YES];
}


- (void)hideStartDatePicker {
    // Set the visible flag to false
    self.startDatePickerVisible = NO;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:1];
    
    // Delete the date picker row and reload the label row
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


- (void)hideEndDatePicker {
    // Set the visible flag to false
    self.endDatePickerVisible = NO;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:2];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:2];
    
    // Delete the date picker row and reload the label row
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


- (void)startDateChanged:(UIDatePicker*)datePicker
{
    // Update the variable and label when the date picker value changes
    self.startDate = datePicker.date;
    self.startDateLabel.text = [self formatDate:self.startDate];
}


- (void)endDateChanged:(UIDatePicker*)datePicker
{
    // Update the variable and label when the date picker value changes
    self.endDate = datePicker.date;
    self.endDateLabel.text = [self formatDate:self.endDate];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If the date picker is visible for this section, return 2 otherwise call the super method
    if ((section == 1 && self.startDatePickerVisible) || (section == 2 && self.endDatePickerVisible)) {
        return 2;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}


// Override this method to enable the date picker cell to be created
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // If the cell should be a date picker cell
    if ((indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 1)) {
        
        NSString *identifier = (indexPath.section == 1) ? @"datePickerStartCell" : @"datePickerEndCell";
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
            
            // Set the action depending on the cell
            if (indexPath.section == 1) {
                [datePicker addTarget:self action:@selector(startDateChanged:) forControlEvents:UIControlEventValueChanged];
            } else {
                [datePicker addTarget:self action:@selector(endDateChanged:) forControlEvents:UIControlEventValueChanged];
            }
        }
        
        return cell;
        
    } else {
        // If the cell is not a date picker cell, call the super method
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // If this cell contains a cell picker, manually set the cell height to fit the picker
    if ((indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 1)) {
        return 217.0f;
    }
    
    // Otherwise call the super method
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If this cell is a date label, enable selections so the user can click to show or hide the date picker
    if ((indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 2 && indexPath.row == 0)) {
        return indexPath;
    }
    
    // Otherwise return nil to prevent cell selection
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Hide the keyboard if a cell was clicked on
    [self.nameField resignFirstResponder];
    
    // If the cell is the start date label cell
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        // Toggle the visibility of the date picker cell
        if (!self.startDatePickerVisible) {
            [self showStartDatePicker];
            
            // Also hide the other date picker if visible
            if (self.endDatePickerVisible) {
                [self hideEndDatePicker];
            }
            
        } else {
            [self hideStartDatePicker];
        }
        
    // If the cell is the end date label cell
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        
        // Toggle the visibility of the date picker cell
        if (!self.endDatePickerVisible) {
            [self showEndDatePicker];
            
            // Also hide the other date picker if visible
            if (self.startDatePickerVisible) {
                [self hideStartDatePicker];
            }
            
        } else {
            [self hideEndDatePicker];
        }
    }
}


// This method is required to add dynamic cells to a table view containing static cells
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 1)) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}


@end

