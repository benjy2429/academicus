//
//  AssessmentDetailTableViewController.m
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "AssessmentDetailTableViewController.h"

@implementation AssessmentDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weightingField.tag = 1;
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Assessment";
        self.nameField.text = self.itemToEdit.name;
        self.weightingField.text = [NSString stringWithFormat:@"%.2f", [self.itemToEdit.weighting floatValue]];
        self.deadlineDate = self.itemToEdit.deadline;
        self.deadlineLabel.text = [self formatDate:self.deadlineDate];

        self.deadlineDatePickerVisible = NO;

        // If the assessment has a reminder, display its datepicker
        if (self.itemToEdit.reminder != nil) {
            self.reminderSwitch.on = YES;
            self.reminderDate = self.itemToEdit.reminder;
            self.reminderLabel.text = [self formatDate:self.reminderDate];
            [self showReminderDatePicker];
        } else {
            self.reminderDatePickerVisible = NO;
            self.reminderDate = [NSDate date];
            self.reminderLabel.text = @"No reminder set";
        }
    } else {
        // If no item was passed through, create default date values
        self.deadlineDate = [NSDate date];
        self.reminderDate = [NSDate date];
        
        self.reminderDatePickerVisible = NO;
        self.deadlineDatePickerVisible = NO;
        
        // Assign the stored dates to the labels on the view
        self.deadlineLabel.text = [self formatDate:self.deadlineDate];
        self.reminderLabel.text = @"No reminder set";
    }
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
    //Check that the name length is less than 30
    if ([self.nameField.text length] > 30) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The name must be less than 30 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check for weighting value
    if ([self.weightingField.text floatValue] < 0 || [self.weightingField.text floatValue] > 100) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The subject weighting must be 0-100%" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the weighting for this assessment is permissible given weightings for other assessment criteria
    if ([self.weightingField.text floatValue] + self.moduleAllocated > 100) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The subject weighting is too high. The weighting for all assessments in a subject should total 100%" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
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
        // If editing, update the item and call the delegate method to dismiss the view
        self.itemToEdit.name = self.nameField.text;
        self.itemToEdit.weighting = [NSNumber numberWithFloat:[self.weightingField.text floatValue]];
        
        // 3 Week Add Grade Reminder Notification
        // Set a notification 3 weeks after the deadline if notifications are enabled
        if (self.itemToEdit.deadline != self.deadlineDate) {
            self.itemToEdit.deadline = self.deadlineDate;
            [self createDeadlineReminder:self.itemToEdit byReplacing:YES];
        }

        // User Reminder Notification
        // If a reminder exists, cancel the notification
        if (self.itemToEdit.reminder != nil) {
            [self removeReminder:self.itemToEdit];
        }
        
        // If the reminder has been enabled, schedule a new notification
        if (self.reminderSwitch.on) {
            self.itemToEdit.reminder = self.reminderDate;
            [self createReminder:self.itemToEdit];
        } else {
            self.itemToEdit.reminder = nil;
        }
        
        [self.delegate AssessmentDetailTableViewController:self didFinishEditingAssessment:self.itemToEdit];
        
    } else {
        // If adding, create a new item and call the delegate method to dismiss the view
        AssessmentCriteria *newAssessment = [NSEntityDescription insertNewObjectForEntityForName:@"AssessmentCriteria" inManagedObjectContext:self.managedObjectContext];
        newAssessment.hasGrade = [NSNumber numberWithBool:NO];
        newAssessment.name = self.nameField.text;
        newAssessment.weighting = [NSNumber numberWithFloat:[self.weightingField.text floatValue]];
        newAssessment.deadline = self.deadlineDate;
        newAssessment.reminder = (self.reminderSwitch.on) ? self.reminderDate : nil;
        
        // 3 Week Add Grade Reminder Notification
        [self createDeadlineReminder:newAssessment byReplacing:NO];
        
        // User Reminder Notification
        // Check if a reminder has been added so a new notification can be scheduled
        if (self.reminderSwitch.on) {
            [self createReminder:newAssessment];
        }
        
        [self.delegate AssessmentDetailTableViewController:self didFinishAddingAssessment:newAssessment];
    }
}


- (IBAction)cancel {
    // Delegate method when the cancel button is pressed
    [self.delegate AssessmentDetailTableViewControllerDidCancel:self];
}


- (IBAction)reminderSwitchChanged:(UISwitch*)sender {
    // When the switch is set to on, display the date picker and hide any open keyboards
    if (sender.on) {
        [self showReminderDatePicker];
        
        // Hide the keyboard if the switch is set to on
        [self.nameField resignFirstResponder];
        [self.weightingField resignFirstResponder];
    } else {
        // Otherwise hide the date picker and reset the reminder value
        [self hideReminderDatePicker];
        self.reminderLabel.text = @"No reminder set";
    }
}


#pragma mark - Local Notifications

// Create a reminder that the user can set
- (void)createReminder:(AssessmentCriteria *)assessment {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = self.reminderDate;
    notification.alertBody = [NSString stringWithFormat:@"%@ is due soon!", assessment.name];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.userInfo = @{@"reminder": assessment.reminder};
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


// Delete a reminder that the user has set
- (void)removeReminder:(AssessmentCriteria *)assessment {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSDictionary *userInfo = notification.userInfo;
        
        if ([userInfo valueForKey:@"reminder"] == self.itemToEdit.reminder) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}


// If enabled, automatically create a reminder 3 weeks after the deadline to notify the user to add a grade
- (void)createDeadlineReminder:(AssessmentCriteria *)assessment byReplacing:(BOOL)willReplace {
    // Calculate the date 3 weeks after the deadline to set a notification reminder
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:21];
    NSDate *deadlineReminderDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.deadlineDate options:0];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"notificationsEnabled"] && [deadlineReminderDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
        
        if (willReplace) { [self removeDeadlineReminder:assessment]; }
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = deadlineReminderDate;
        notification.alertBody = [NSString stringWithFormat:@"Don't forget to add a grade for %@!", assessment.name];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.userInfo = @{@"isDeadlineReminder" : @YES, @"deadline": assessment.deadline};
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


// If enabled, remove an automatic add grade reminder which was set 3 weeks after the deadline
- (void)removeDeadlineReminder:(AssessmentCriteria *)assessment {
    // Find the existing noification and delete it
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSDictionary *userInfo = notification.userInfo;
        
        if ([[userInfo valueForKey:@"isDeadlineReminder"] boolValue] && [userInfo valueForKey:@"deadline"] == assessment.deadline) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // When the name field is edited, hide any visible date pickers
    if (self.deadlineDatePickerVisible) {
        [self hideDeadlineDatePicker];
    }
}


// When the text field changes, check that the new character is valid
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 1) {
        return ([newText length] < 3 || [newText isEqual: @"100"] || [newText isEqual: @"100."] || [newText isEqual: @"100.0"] || [newText isEqual: @"100.00"] || ([newText characterAtIndex:2] == '.' && [newText length] < 6) || ([newText characterAtIndex:1] == '.' && [newText length] < 5));
    }
    return YES;
}


// When the user finishes with a textfield, ensure the contents are in the correct format
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        textField.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
    }
}


#pragma mark - Date Picker

- (NSString*)formatDate:(NSDate*)date {
    // Helper method to quickly format date strings to be displayed in labels
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E, d/M/yy, h:mm a"];
    return [formatter stringFromDate:date];
}


- (void)showDeadlineDatePicker {
    // Set the visible flag to true
    self.deadlineDatePickerVisible = YES;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:2];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:2];
    
    // Insert a new row for the date picker and reload the label row
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    // Set the label to the date shown
    self.deadlineLabel.text = [self formatDate:self.deadlineDate];
}


- (void)showReminderDatePicker {
    // Set the visible flag to true
    self.reminderDatePickerVisible = YES;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:3];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:3];
    
    // Insert a new row for the date picker and reload the label row
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    // Set the label to the date shown
    self.reminderLabel.text = [self formatDate:self.reminderDate];
}


- (void)hideDeadlineDatePicker {
    // Set the visible flag to false
    self.deadlineDatePickerVisible = NO;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:2];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:2];
    
    // Delete the date picker row and reload the label row
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


- (void)hideReminderDatePicker {
    // Set the visible flag to false
    self.reminderDatePickerVisible = NO;
    // Find the rows of the label and the date picker
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:0 inSection:3];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:3];
    
    // Delete the date picker row and reload the label row
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


- (void)deadlineDateChanged:(UIDatePicker*)datePicker {
    // Update the variable and label when the date picker value changes
    self.deadlineDate = datePicker.date;
    self.deadlineLabel.text = [self formatDate:self.deadlineDate];
}


- (void)reminderDateChanged:(UIDatePicker*)datePicker {
    // Update the variable and label when the date picker value changes
    self.reminderDate = datePicker.date;
    self.reminderLabel.text = [self formatDate:self.reminderDate];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If the date picker is visible for this section, return 2 otherwise call the super method
    if ((section == 2 && self.deadlineDatePickerVisible) || (section == 3 && self.reminderDatePickerVisible)) {
        return 2;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}


// Override this method to enable the date picker cell to be created
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // If the cell should be a date picker cell
    if ((indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 1)) {
        
        NSString *identifier = (indexPath.section == 2) ? @"datePickerDeadlineCell" : @"datePickerReminderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        // Create a new cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Add a date picker view to the cell
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
            datePicker.tag = 100;
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            [cell.contentView addSubview:datePicker];
            
            // Set the action depending on the cell
            if (indexPath.section == 2) {
                [datePicker addTarget:self action:@selector(deadlineDateChanged:) forControlEvents:UIControlEventValueChanged];
                [datePicker setDate:self.deadlineDate animated:YES];
            } else {
                [datePicker addTarget:self action:@selector(reminderDateChanged:) forControlEvents:UIControlEventValueChanged];
                [datePicker setMinimumDate:[NSDate date]];
                // Only set a maximum date if the deadline is in the future
                if ([self.deadlineDate compare:[NSDate date]] == NSOrderedDescending) {
                    [datePicker setMaximumDate:self.itemToEdit.deadline];
                }
                [datePicker setDate:self.reminderDate animated:YES];
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
    if (indexPath.section == 2 && indexPath.row == 0) {
        return indexPath;
    }
    
    // Otherwise return nil to prevent cell selection
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Hide the keyboard if a cell was clicked on
    [self.nameField resignFirstResponder];
    [self.weightingField resignFirstResponder];
    
    // If the cell is the deadline date label cell
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        // Toggle the visibility of the date picker cell
        if (!self.deadlineDatePickerVisible) {
            [self showDeadlineDatePicker];
        } else {
            [self hideDeadlineDatePicker];
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

