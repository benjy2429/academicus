//
//  YearDetailTableViewController.m
//  academicus
//
//  Created by Ben on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "YearDetailTableViewController.h"

@interface YearDetailTableViewController ()

@end

@implementation YearDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Year";
        self.nameField.text = self.itemToEdit.name;
        self.startDate = self.itemToEdit.startDate;
        self.endDate = self.itemToEdit.endDate;
        
        self.doneBtn.enabled = YES;
    } else {
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
        self.doneBtn.enabled = NO;
    }
    
    self.startDateLabel.text = [self formatDate:self.startDate];
    self.endDateLabel.text = [self formatDate:self.endDate];
    
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
    [self.delegate YearDetailTableViewControllerDidCancel:self];
}


- (IBAction)done
{
    if (self.itemToEdit != nil) {
        // If editing, update the item and call the delegate method to dismiss the view
        self.itemToEdit.name = self.nameField.text;
        self.itemToEdit.startDate = self.startDate;
        self.itemToEdit.endDate = self.endDate;
        [self.delegate YearDetailTableViewController:self didFinishEditingYear:self.itemToEdit];
        
    } else {
        // If adding, create a new item and call the delegate method to dismiss the view
        Year *newYear = [[Year alloc] init];
        newYear.name = self.nameField.text;
        newYear.startDate = self.startDate;
        newYear.endDate = self.endDate;
        [self.delegate YearDetailTableViewController:self didFinishAddingYear:newYear];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Only enable the done button when the fields are not empty
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBtn.enabled = ([newText length] > 0);
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.datePickerVisible) {
        [self hideDatePicker];
    }
}


- (NSString*)formatDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    return [formatter stringFromDate:date];
}


- (void)showDatePickerAtIndexPath:(NSIndexPath*)indexPath
{
    self.datePickerVisible = YES;
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*) [datePickerCell viewWithTag:100];
    [datePicker setDate:self.endDate animated:YES];
}


- (void)hideDatePicker
{
    self.datePickerVisible = NO;
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*) [datePickerCell viewWithTag:100];
    [datePicker setDate:self.endDate animated:YES];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"datePickerCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"datePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
            datePicker.tag = 100;
            datePicker.datePickerMode = UIDatePickerModeDate;
            [cell.contentView addSubview:datePicker];
            
            if (indexPath.row == 1) {
                [datePicker addTarget:self action:@selector(startDateChanged:) forControlEvents:UIControlEventValueChanged];
            } else if (indexPath.row == 2) {
                [datePicker addTarget:self action:@selector(endDateChanged:) forControlEvents:UIControlEventValueChanged];
            }
        }
        
        return cell;
        
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (void)startDateChanged:(UIDatePicker*)datePicker
{
    self.startDate = datePicker.date;
    self.startDateLabel.text = [self formatDate:self.startDate];
}


- (void)endDateChanged:(UIDatePicker*)datePicker
{
    self.endDate = datePicker.date;
    self.endDateLabel.text = [self formatDate:self.endDate];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 && self.datePickerVisible) {
        return 3;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datePickerVisible) {
        if (indexPath.section == 1 && indexPath.row == 2) {
            return 217.0f;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return indexPath;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.nameField resignFirstResponder];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (!self.datePickerVisible) {
            [self showDatePickerAtIndexPath:indexPath];
        } else {
            [self hideDatePicker];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

@end
