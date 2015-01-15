//
//  PersonalTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Portfolio.h"

@class PersonalTableViewController;

@protocol PersonalTableViewControllerDelegate <NSObject>

- (void)personalTableViewControllerDidCancel:(PersonalTableViewController*)controller;
- (void)personalTableViewController:(PersonalTableViewController*)controller didFinishSavingPortfolio:(Portfolio*)qualification;

@end

@interface PersonalTableViewController : UITableViewController

@property (weak) id <PersonalTableViewControllerDelegate> delegate;
@property (strong) Portfolio *itemToEdit;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *addressField;
@property (weak, nonatomic) IBOutlet UITextField *telephoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *websiteField;

@end
