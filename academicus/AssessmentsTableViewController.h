//
//  AssessmentsTableViewController.h
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"
#import "AssessmentDetailTableViewController.h"
#import "AssessmentGradeTableViewController.h"

@interface AssessmentsTableViewController : UITableViewController <AssessmentDetailTableViewControllerDelegate, AssessmentGradeTableViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (weak) Subject *subject;

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

// This variable is used to determine whether the user clicked the edit button, or swiped a row
@property (assign) BOOL inSwipeDeleteMode;
@property (assign) BOOL isSubjectExpanded;
@property (assign) float expandSize;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UILabel *moduleProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end