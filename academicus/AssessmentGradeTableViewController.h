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
#define NOTES_PLACEHOLDER @"Write additional comments and information here."

@class AssessmentGradeTableViewController;

@protocol AssessmentGradeTableViewControllerDelegate <NSObject>

- (void)AssessmentGradeTableViewControllerDidCancel:(AssessmentGradeTableViewController*)controller;
- (void)AssessmentGradeTableViewController:(AssessmentGradeTableViewController*)controller didFinishEditingAssessment:(AssessmentCriteria*)assessment;

@end

@interface AssessmentGradeTableViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>

@property (weak) id <AssessmentGradeTableViewControllerDelegate> delegate;

@property (strong) AssessmentCriteria *itemToEdit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *gradeField;
@property (weak, nonatomic) IBOutlet UITextView *positiveFeedbackField;
@property (weak, nonatomic) IBOutlet UITextView *negativeFeedbackField;
@property (weak, nonatomic) IBOutlet UITextView *notesField;
@property (weak, nonatomic) IBOutlet UITextField *pictureField;

@property (assign) int currentRating;
@property (weak, nonatomic) IBOutlet UIView *ratingCell;
@property (weak, nonatomic) IBOutlet UIButton *ratingStar1;
@property (weak, nonatomic) IBOutlet UIButton *ratingStar2;
@property (weak, nonatomic) IBOutlet UIButton *ratingStar3;
@property (weak, nonatomic) IBOutlet UIButton *ratingStar4;
@property (weak, nonatomic) IBOutlet UIButton *ratingStar5;

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@end
