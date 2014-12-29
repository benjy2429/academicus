//
//  AssessmentGradeTableViewController.h
//  academicus
//
//  Created by Luke on 22/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentCriteria.h"

#define POSITIVE_FEEDBACK_PLACEHOLDER @"What did you enjoy? What skills did you learn?"
#define NEGATIVE_FEEDBACK_PLACEHOLDER @"What didn't you enjoy?"

@class AssessmentGradeTableViewController;

@protocol AssessmentGradeTableViewControllerDelegate <NSObject>

- (void)AssessmentGradeTableViewControllerDidCancel:(AssessmentGradeTableViewController*)controller;
- (void)AssessmentGradeTableViewController:(AssessmentGradeTableViewController*)controller didFinishEditingAssessment:(AssessmentCriteria*)assessment;

@end

@interface AssessmentGradeTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak) id <AssessmentGradeTableViewControllerDelegate> delegate;

@property (strong) AssessmentCriteria *itemToEdit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *gradeField;
@property (weak, nonatomic) IBOutlet UITextField *ratingField;
@property (weak, nonatomic) IBOutlet UITextView *positiveFeedbackField;
@property (weak, nonatomic) IBOutlet UITextView *negativeFeedbackField;
@property (weak, nonatomic) IBOutlet UITextView *notesField;
@property (weak, nonatomic) IBOutlet UITextField *pictureField;

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@end
