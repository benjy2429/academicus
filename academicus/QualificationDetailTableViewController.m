//
//  AddQualificationTableViewController.m
//  academicus
//
//  Created by Ben on 19/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "QualificationDetailTableViewController.h"

@implementation QualificationDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];   

    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Qualification";
        self.nameField.text = self.itemToEdit.name;
        self.institutionField.text = self.itemToEdit.institution;
    }
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Open the keyboard automatically when the view appears
    [self.nameField becomeFirstResponder];
}


// Validate the input data
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
    //Check for the presence of an institution
    if ([self.institutionField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"You must provide an institution" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the institution length is less than 50
    if ([self.institutionField.text length] > 50) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The institution must be less than 50 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
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
        self.itemToEdit.institution = self.institutionField.text;
        
        [self.delegate QualificationDetailTableViewController:self didFinishEditingQualification:self.itemToEdit];
        
    } else {
        // Else if the item is new, create a new entity
        Qualification *newQualification = [NSEntityDescription insertNewObjectForEntityForName:@"Qualification" inManagedObjectContext:self.managedObjectContext];
        
        newQualification.name = self.nameField.text;
        newQualification.institution = self.institutionField.text;
        
        [self.delegate QualificationDetailTableViewController:self didFinishAddingQualification:newQualification];
    }
}


// Called when the cancel navigation bar button is pressed
- (IBAction)cancel {
    // Dismiss the view controller
    [self.delegate QualificationDetailTableViewControllerDidCancel:self];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Disable the ability to select table rows
    return nil;
}


@end

