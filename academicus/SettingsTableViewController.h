//
//  SettingsTableViewController.h
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "LoginViewController.h"

@interface SettingsTableViewController : UITableViewController <LoginViewControllerDelegate>

//Security section
@property (weak, nonatomic) IBOutlet UITableViewCell *changePasscodeRow;
@property (weak, nonatomic) IBOutlet UISwitch *passcodeSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *touchIdRow;
@property (weak, nonatomic) IBOutlet UISwitch *touchIdSwitch;

@end