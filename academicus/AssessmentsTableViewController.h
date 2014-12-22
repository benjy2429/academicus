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

@interface AssessmentsTableViewController : UITableViewController <AssessmentDetailTableViewControllerDelegate>

@property (weak) Subject *subject;

// This variable is used to determine whether the user clicked the edit button, or swiped a row
@property (assign) BOOL inSwipeDeleteMode;

@end