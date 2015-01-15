//
//  PersonalTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "PersonalTableViewController.h"

@implementation PersonalTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the default values
    self.nameField.text = self.itemToEdit.name;
    self.addressField.text = self.itemToEdit.address;
    self.telephoneField.text = self.itemToEdit.phone;
    self.emailField.text = self.itemToEdit.email;
    self.websiteField.text = self.itemToEdit.website;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Open the keyboard automatically when the view appears
    [self.nameField becomeFirstResponder];
}


- (IBAction)done
{
    self.itemToEdit.name = self.nameField.text;
    self.itemToEdit.address = self.addressField.text;
    self.itemToEdit.phone = self.telephoneField.text;
    self.itemToEdit.email = self.emailField.text;
    self.itemToEdit.website = self.websiteField.text;
    
    [self.delegate personalTableViewController:self didFinishSavingPortfolio:self.itemToEdit];
}


- (IBAction)cancel
{
    [self.delegate personalTableViewControllerDidCancel:self];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable the ability to select table rows
    return nil;
}

@end
