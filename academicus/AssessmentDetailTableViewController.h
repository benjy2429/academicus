//
//  AssessmentDetailTableViewController.h
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentCriteria.h"

@class AssessmentDetailTableViewController;

// Delegate Protocol
@protocol AssessmentDetailTableViewControllerDelegate <NSObject>
- (void)AssessmentDetailTableViewControllerDidCancel:(AssessmentDetailTableViewController*)controller;
- (void)AssessmentDetailTableViewController:(AssessmentDetailTableViewController*)controller didFinishAddingAssessment:(AssessmentCriteria*)assessment;
- (void)AssessmentDetailTableViewController:(AssessmentDetailTableViewController*)controller didFinishEditingAssessment:(AssessmentCriteria*)assessment;
@end

@interface AssessmentDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (weak) id <AssessmentDetailTableViewControllerDelegate> delegate;
@property (strong) AssessmentCriteria *itemToEdit;

// Percentage of the module that has already been allocated (passed in)
@property (assign) float weightingAllocated;

// IBOutlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *weightingField;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;

// Temporary variables to store the dates from the date pickers
@property (strong) NSDate *deadlineDate;
@property (strong) NSDate *reminderDate;

// Boolean flags to determine whether the date pickers are visible
@property (assign) BOOL deadlineDatePickerVisible;
@property (assign) BOOL reminderDatePickerVisible;

@end