//
//  WorkDetailTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkExperience.h"

#define COMPANY_ADDRESS_PLACEHOLDER @"Address"

@class WorkDetailTableViewController;

@protocol WorkDetailTableViewControllerDelegate <NSObject>

- (void)workDetailTableViewControllerDidCancel:(WorkDetailTableViewController*)controller;
- (void)workDetailTableViewController:(WorkDetailTableViewController*)controller didFinishAddingWork:(WorkExperience*)work;
- (void)workDetailTableViewController:(WorkDetailTableViewController*)controller didFinishEditingWork:(WorkExperience*)work;

@end

@interface WorkDetailTableViewController : UITableViewController <UITextViewDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (weak) id <WorkDetailTableViewControllerDelegate> delegate;
@property (strong) WorkExperience *itemToEdit;

@property (weak, nonatomic) IBOutlet UITextField *jobTitleField;
@property (weak, nonatomic) IBOutlet UITextField *companyNameField;
@property (weak, nonatomic) IBOutlet UITextView *companyAddressField;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *refereeNameField;
@property (weak, nonatomic) IBOutlet UITextField *refereeEmailField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;

@property (strong) NSDate* startDate;
@property (strong) NSDate* endDate;

// Use flags to determine whether the date pickers are hidden or visible
@property (assign) BOOL startDatePickerVisible;
@property (assign) BOOL endDatePickerVisible;

@end
