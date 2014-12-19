//
//  AddQualificationTableViewController.h
//  academicus
//
//  Created by Ben on 19/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Qualification.h"

@class AddQualificationTableViewController;

@protocol AddQualificationTableViewControllerDelegate <NSObject>

- (void)addQualificationTableViewControllerDidCancel:(AddQualificationTableViewController*)controller;
- (void)addQualificationTableViewController:(AddQualificationTableViewController*)controller didFinishAddingQualification:(Qualification*)qualification;

@end

@interface AddQualificationTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak) id <AddQualificationTableViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end
