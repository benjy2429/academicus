//
//  SubjectDetailTableViewController.m
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "SubjectDetailTableViewController.h"

@interface SubjectDetailTableViewController ()

@end

@implementation SubjectDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameField.tag = 0;
    self.weightingField.tag = 1;
    self.targetField.tag = 2;
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Subject";
        
        self.nameField.text = self.itemToEdit.name;
        self.weightingField.text = [NSString stringWithFormat: @"%.1f", self.itemToEdit.yearWeighting];
        self.weighting = self.itemToEdit.yearWeighting;
        self.targetField.text = [NSString stringWithFormat: @"%i", self.itemToEdit.targetGrade];
        self.target = self.itemToEdit.targetGrade;
        
        if (CGColorGetNumberOfComponents(self.itemToEdit.colour.CGColor) >= 3) {
            const CGFloat *colourComponents = CGColorGetComponents(self.itemToEdit.colour.CGColor);
            self.colourField.text = [NSString stringWithFormat: @"R: %f, G: %f, B:%f", colourComponents[0],colourComponents[1],colourComponents[2]];
        }
        //self.locationField.text = self.itemToEdit.location; //TODO: Get locaiton value
        
        self.teacherNameField.text = self.itemToEdit.teacherName;
        self.teacherEmailField.text = self.itemToEdit.teacherEmail;
        
        self.doneBtn.enabled = YES;
    } else {     
        self.doneBtn.enabled = NO;
      
        //TODO: Complete
        //TODO: This has not been added for all files so check other classes!!
    }
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
    [self.delegate SubjectDetailTableViewControllerDidCancel:self];
}


- (IBAction)done
{
    if (self.itemToEdit != nil) {
        // If editing, update the item and call the delegate method to dismiss the view
        self.itemToEdit.name = self.nameField.text;
        self.itemToEdit.yearWeighting = self.weighting;
        self.itemToEdit.targetGrade = self.target;
        //self.itemToEdit.colour //TODO: Set colour value
        //self.itemToEdit.location //TODO: Set locaiton value
        self.itemToEdit.teacherName = self.teacherNameField.text;
        self.itemToEdit.teacherEmail = self.teacherEmailField.text;
        
        [self.delegate SubjectDetailTableViewController:self didFinishEditingSubject: self.itemToEdit];
        
    } else {
        // If adding, create a new item and call the delegate method to dismiss the view
        Subject *newSubject = [[Subject alloc] init];
        newSubject.name = self.nameField.text;
        newSubject.yearWeighting = self.weighting;
        newSubject.targetGrade = self.target;
        //newSubject.colour //TODO: Set colour value
        //newSubject.location //TODO: Set locaiton value
        newSubject.teacherName = self.teacherNameField.text;
        newSubject.teacherEmail = self.teacherEmailField.text;
        [self.delegate SubjectDetailTableViewController:self didFinishAddingSubject:newSubject];
    }
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable the ability to select table rows
    return nil;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        //If weighting field
        case 1:
            //[textField setText:[NSString stringWithFormat:@"%@%%", string]];
            return ([newText length] < 3 || [newText isEqual: @"100"] || ([newText characterAtIndex:2] == '.' && [newText length] < 6));
            break;
        //If target field
        case 2:
            //[textField setText:[NSString stringWithFormat:@"%@%%", string]];
            return ([newText length] < 3 || [newText isEqual: @"100"]);
            break;
        //Otherwise
        default:
            return YES;
    }
    // Only enable the done button when the required fields are not empty
    self.doneBtn.enabled = (textField.tag == 0 && [newText length] > 0);
}
//TODO: tidy this up

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1 || textField.tag == 2) {
        //[textField setText:[NSString stringWithFormat:@"%@%%", textField.text]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
