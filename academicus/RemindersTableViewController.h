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

//Constants for fetched results controller predicate
#define UPCOMING_PREDICATE @"deadline > %@ AND hasGrade == false" //When the upcoming segmented control button is selected
#define PAST_PREDICATE @"deadline <= %@ OR hasGrade == true" //When the past segmented control button is selected

@interface RemindersTableViewController : UITableViewController <AssessmentGradeTableViewControllerDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

//True if past segmented control button is selected
@property (assign) BOOL isPast;

//Linked to segmented control
- (IBAction)segmentSwitch:(id)sender;

@end
