//
//  AddQualificationTableViewController.m
//  academicus
//
//  Created by Ben on 19/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "QualificationDetailTableViewController.h"

@interface QualificationDetailTableViewController ()

@end

@implementation QualificationDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Qualification";
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
    [self.delegate QualificationDetailTableViewControllerDidCancel:self];
}


- (IBAction)done
{
    if (self.itemToEdit != nil) {
        // If editing, update the item and call the delegate method to dismiss the view
        self.itemToEdit.name = self.nameField.text;
        [self.delegate QualificationDetailTableViewController:self didFinishEditingQualification:self.itemToEdit];
        
    } else {
        // If adding, create a new item and call the delegate method to dismiss the view
        Qualification *newQualification = [[Qualification alloc] init];
        newQualification.name = self.nameField.text;
        [self.delegate QualificationDetailTableViewController:self didFinishAddingQualification:newQualification];
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
