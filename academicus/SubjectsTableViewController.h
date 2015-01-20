//
//  SubjectsTableViewController.h
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Year.h"
#import "Subject.h"
#import "SubjectDetailTableViewController.h"
#import "AssessmentsTableViewController.h"

@interface SubjectsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, SubjectDetailTableViewControllerDelegate>

@property (weak) Year *year;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

// This variable is used to determine whether the user clicked the edit button, or swiped a row
@property (assign) BOOL inSwipeDeleteMode;

// Used to calculate the total subject weights for the year
@property (nonatomic, assign) float weightingAllocated;

@end
