//
//  AssessmentDetailTableViewController.m
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "AssessmentDetailTableViewController.h"

@interface AssessmentDetailTableViewController ()

@end

@implementation AssessmentDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Assessment";
        self.nameField.text = self.itemToEdit.name;
        self.doneBtn.enabled = YES;
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
    [self.delegate AssessmentDetailTableViewControllerDidCancel:self];
}


- (IBAction)done
{
    if (self.itemToEdit != nil) {
        // If editing, update the item and call the delegate method to dismiss the view
        self.itemToEdit.name = self.nameField.text;
        [self.delegate AssessmentDetailTableViewController:self didFinishEditingAssessment: self.itemToEdit];
        
    } else {
        // If adding, create a new item and call the delegate method to dismiss the view
        AssessmentCriteria *newAssessment = [[AssessmentCriteria alloc] init];
        newAssessment.name = self.nameField.text;
        [self.delegate AssessmentDetailTableViewController:self didFinishAddingAssessment:newAssessment];
    }
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable the ability to select table rows
    return nil;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Only enable the done button when the fields are not empty
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBtn.enabled = ([newText length] > 0);
    
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
