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
#import "AssessmentCriteria.h"

@interface SettingsTableViewController : UITableViewController <LoginViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;

//Security section
@property (weak, nonatomic) IBOutlet UITableViewCell *changePasscodeRow;
@property (weak, nonatomic) IBOutlet UISwitch *passcodeSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *touchIdRow;
@property (weak, nonatomic) IBOutlet UISwitch *touchIdSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *savePhotosSwitch;

@end