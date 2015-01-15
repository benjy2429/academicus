//
//  WorkTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkExperience.h"
#import "WorkDetailTableViewController.h"

@interface WorkTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, WorkDetailTableViewControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

// This variable is used to determine whether the user clicked the edit button, or swiped a row
@property (assign) BOOL inSwipeDeleteMode;

@end
