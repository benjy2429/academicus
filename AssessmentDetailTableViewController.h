//
//  AssessmentDetailTableViewController.h
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentCriteria.h"
#import "AssessmentCriteria.h"

@class AssessmentDetailTableViewController;

@protocol AssessmentDetailTableViewControllerDelegate <NSObject>

- (void)AssessmentDetailTableViewControllerDidCancel:(AssessmentDetailTableViewController*)controller;
- (void)AssessmentDetailTableViewController:(AssessmentDetailTableViewController*)controller didFinishAddingAssessment:(AssessmentCriteria*)assessment;
- (void)AssessmentDetailTableViewController:(AssessmentDetailTableViewController*)controller didFinishEditingAssessment:(AssessmentCriteria*)assessment;

@end

@interface AssessmentDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak) id <AssessmentDetailTableViewControllerDelegate> delegate;

@property (strong) AssessmentCriteria *itemToEdit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *weightingField;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@property (strong) NSDate *deadlineDate;
@property (strong) NSDate *reminderDate;
@property (assign) BOOL deadlineDatePickerVisible;
@property (assign) BOOL reminderDatePickerVisible;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;


@end