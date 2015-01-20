//
//  HobbiesTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "HobbiesTableViewController.h"

@implementation HobbiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the default values
    self.hobbiesField.text = self.itemToEdit.hobbies;
}


// Called when the done navigation bar button is pressed
- (IBAction)done {
    // Save the hobbies from the text field into the managed object
    self.itemToEdit.hobbies = self.hobbiesField.text;
    
    // Call the delegate method to dismiss the view
    [self.delegate hobbiesTableViewController:self didFinishSavingPortfolio:self.itemToEdit];
}


// Called when the cancel navigation bar button is pressed
- (IBAction)cancel {
    // Call the delegate method to dismiss the view
    [self.delegate hobbiesTableViewControllerDidCancel:self];
}


@end

