//
//  RemindersTableViewController.h
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"
#import "AssessmentCriteria.h"
#import "AssessmentGradeTableViewController.h"

#define UPCOMING_PREDICATE @"deadline > %@ AND hasGrade == false"
#define PAST_PREDICATE @"deadline <= %@ OR hasGrade == true"

@interface RemindersTableViewController : UITableViewController <AssessmentGradeTableViewControllerDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

@property (assign) BOOL isPast;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

- (IBAction)segmentSwitch:(id)sender;

@end
