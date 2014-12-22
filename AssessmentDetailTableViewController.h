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

@end