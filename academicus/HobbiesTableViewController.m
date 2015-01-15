//
//  HobbiesTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "HobbiesTableViewController.h"

@implementation HobbiesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the default values
    self.hobbiesField.text = self.itemToEdit.hobbies;
}


- (IBAction)done
{
    self.itemToEdit.hobbies = self.hobbiesField.text;
    
    [self.delegate hobbiesTableViewController:self didFinishSavingPortfolio:self.itemToEdit];
}


- (IBAction)cancel
{
    [self.delegate hobbiesTableViewControllerDidCancel:self];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable the ability to select table rows
    return nil;
}

@end
