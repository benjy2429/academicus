//
//  AddQualificationTableViewController.m
//  academicus
//
//  Created by Ben on 19/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "QualificationDetailTableViewController.h"

@implementation QualificationDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];   

    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Qualification";
        self.nameField.text = self.itemToEdit.name;
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
    // Dismiss the view controller
    [self.delegate QualificationDetailTableViewControllerDidCancel:self];
}


- (BOOL) isEnteredDataValid
{
    //Check for the presence of a name
    if ([self.nameField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"You must provide a name" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the name length is less than 30
    if ([self.nameField.text length] > 30) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"The name must be less than 30 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
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
        [self.delegate QualificationDetailTableViewController:self didFinishEditingQualification:self.itemToEdit];
        
    } else {
        // Else if the item is new, create a new entity
        Qualification *newQualification = [NSEntityDescription insertNewObjectForEntityForName:@"Qualification" inManagedObjectContext:self.managedObjectContext];
        
        newQualification.name = self.nameField.text;
        
        [self.delegate QualificationDetailTableViewController:self didFinishAddingQualification:newQualification];
    }
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable the ability to select table rows
    return nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
