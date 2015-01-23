//
//  AssessmentsTableViewController.h
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Subject.h"
#import "AssessmentDetailTableViewController.h"
#import "AssessmentGradeTableViewController.h"

@interface AssessmentsTableViewController : UITableViewController <AssessmentDetailTableViewControllerDelegate, AssessmentGradeTableViewControllerDelegate, NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (weak) Subject *subject;

// This variable is used to determine whether the user clicked the edit button, or swiped a row
@property (assign) BOOL inSwipeDeleteMode;

// Properties for the table header view
@property (assign) BOOL isSubjectExpanded;
@property (assign) float expandSize;
@property (assign) float weightingAllocated;
@property (assign) float subjectCompleted;
@property (assign) float currentGrade;

// IBOutlets
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UILabel *subjectProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *teacherEmailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *teacherEmailAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *teacherEmailAddressButton;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UILabel *exclamationLabel;

@end