//
//  PersonalTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Portfolio.h"
#import "LocationSearchTableViewController.h"

@class PersonalTableViewController;

@protocol PersonalTableViewControllerDelegate <NSObject>

- (void)personalTableViewControllerDidCancel:(PersonalTableViewController*)controller;
- (void)personalTableViewController:(PersonalTableViewController*)controller didFinishSavingPortfolio:(Portfolio*)qualification;

@end

@interface PersonalTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, LocationSearchTableViewControllerDelegate>

@property (weak) id <PersonalTableViewControllerDelegate> delegate;
@property (strong) Portfolio *itemToEdit;

@property (strong) UIImage* originalPhoto; //The original photo selected by the user
@property (strong) CLPlacemark *addressLocation;

@property (weak, nonatomic) IBOutlet UIImageView *photoView; //The container for the users photo once one has been selected
@property (weak, nonatomic) IBOutlet UILabel *photoPlaceholder; //A label placeholder for the photo field when no photo is stored
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *telephoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *websiteField;

@end
