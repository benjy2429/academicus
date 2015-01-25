//
//  WorkDetailTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "WorkDetailTableViewController.h"

@implementation WorkDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.companyAddressField.text = COMPANY_ADDRESS_PLACEHOLDER;
    self.companyAddressField.textColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Work Experience";
        self.jobTitleField.text = self.itemToEdit.jobTitle;
        self.companyNameField.text = self.itemToEdit.companyName;
        if (![self.itemToEdit.companyAddress isEqualToString:@""]) {
            self.companyAddressField.text = self.itemToEdit.companyAddress;
            self.companyAddressField.textColor = [UIColor blackColor];
        }
        self.startDate = self.itemToEdit.startDate;
        self.endDate = self.itemToEdit.endDate;
        self.descriptionField.text = self.itemToEdit.information;
        self.refereeNameField.text = self.itemToEdit.refereeName;
        self.refereeEmailField.text = self.itemToEdit.refereeEmail;
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
    [self.jobTitleField becomeFirstResponder];
}


- (BOOL) isEnteredDataValid {
    //Check for the presence of a job title
    if ([self.jobTitleField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"You must provide a job title" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the job title length is less than 40
    if ([self.jobTitleField.text length] > 40) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The job title must be less than 40 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check for the presence of a company name
    if ([self.companyNameField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"You must provide a company name" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the company name length is less than 40
    if ([self.companyNameField.text length] > 40) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The company name must be less than 40 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the company address length is less than 100
    if ([self.companyAddressField.text length] > 100) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The company address must be less than 100 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that start date is before end date
    if ([self.startDate timeIntervalSince1970] >= [self.endDate timeIntervalSince1970]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The start date must be before the end date" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the referee name length is less than 30
    if ([self.refereeNameField.text length] > 30) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The referee name must be less than 30 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the referee email length is less than 50
    if ([self.refereeEmailField.text length] > 50) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The referee email must be less than 50 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    return true;
}


- (IBAction)done {
    // Validate the input data
    if (![self isEnteredDataValid]) {return;}
    
    if (self.itemToEdit != nil) {
        // If editing, update the item
        self.itemToEdit.jobTitle = self.jobTitleField.text;
        self.itemToEdit.companyName = self.companyNameField.text;
        self.itemToEdit.companyAddress = (![self.companyAddressField.text isEqualToString:COMPANY_ADDRESS_PLACEHOLDER]) ? self.companyAddressField.text : @"";
        self.itemToEdit.startDate = self.startDate;
        self.itemToEdit.endDate = self.endDate;
        self.itemToEdit.information = self.descriptionField.text;
        self.itemToEdit.refereeName = self.refereeNameField.text;
        self.itemToEdit.refereeEmail = self.refereeEmailField.text;
        
        [self.delegate workDetailTableViewController:self didFinishEditingWork:self.itemToEdit];
        
    } else {
        // If adding, create a new item
        WorkExperience *newWork = [NSEntityDescription insertNewObjectForEntityForName:@"WorkExperience" inManagedObjectContext:self.managedObjectContext];
        newWork.jobTitle = self.jobTitleField.text;
        newWork.companyName = self.companyNameField.text;
        newWork.companyAddress = self.companyAddressField.text;
        newWork.startDate = self.startDate;
        newWork.endDate = self.endDate;
        newWork.information = self.descriptionField.text;
        newWork.refereeName = self.refereeNameField.text;
        newWork.refereeEmail = self.refereeEmailField.text;
        
        [self.delegate workDetailTableViewController:self didFinishAddingWork:newWork];
    }
}


- (IBAction)cancel {
    // Delegate method when the cancel button is pressed
    [self.delegate workDetailTableViewControllerDidCancel:self];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // When the name field is edited, hide any visible date pickers
    if (self.startDatePickerVisible) {
        [self hideStartDatePicker];
    } else if (self.endDatePickerVisible) {
        [self hideEndDatePicker];
    }
}


#pragma mark - UITextViewDelegate

// Remove placeholder text for UITextView elements
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.tag == 201 && [textView.text isEqualToString:COMPANY_ADDRESS_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [textView becomeFirstResponder];
}


// Set placeholder text for UITextView elements
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 201 && [textView.text isEqualToString:@""]) {
        textView.text = COMPANY_ADDRESS_PLACEHOLDER;
        textView.textColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    }
    
    [textView resignFirstResponder];
}


#pragma mark - Date Pickers

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
    [datePicker setDate:self.startDate animated:YES];
}


- (void)showEndDatePicker {
    // Set the visible flag to true
    self.endDatePickerVisible = YES;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:3];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:3];
    
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
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:2];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:2];
    
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
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:3];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:3];
    
    // Delete the date picker row and reload the label row
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


- (void)startDateChanged:(UIDatePicker*)datePicker {
    // Update the variable and label when the date picker value changes
    self.startDate = datePicker.date;
    self.startDateLabel.text = [self formatDate:self.startDate];
}


- (void)endDateChanged:(UIDatePicker*)datePicker {
    // Update the variable and label when the date picker value changes
    self.endDate = datePicker.date;
    self.endDateLabel.text = [self formatDate:self.endDate];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If the date picker is visible for this section, return 2 otherwise call the super method
    if ((section == 2 && self.startDatePickerVisible) || (section == 3 && self.endDatePickerVisible)) {
        return 2;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}


// Override this method to enable the date picker cell to be created
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // If the cell should be a date picker cell
    if ((indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 1)) {
        
        NSString *identifier = (indexPath.section == 2) ? @"datePickerStartCell" : @"datePickerEndCell";
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
            if (indexPath.section == 2) {
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
    if ((indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 1)) {
        return 217.0f;
    }
    
    // Otherwise call the super method
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If this cell is a date label, enable selections so the user can click to show or hide the date picker
    if ((indexPath.section == 2 && indexPath.row == 0) || (indexPath.section == 3 && indexPath.row == 0)) {
        return indexPath;
    }
    
    // Otherwise return nil to prevent cell selection
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Hide the keyboard if a cell was clicked on
    [self.jobTitleField resignFirstResponder];
    [self.companyNameField resignFirstResponder];
    [self.companyAddressField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    [self.refereeNameField resignFirstResponder];
    [self.refereeEmailField resignFirstResponder];
    
    // If the cell is the start date label cell
    if (indexPath.section == 2 && indexPath.row == 0) {
        
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
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        
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
    if ((indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 1)) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

@end
