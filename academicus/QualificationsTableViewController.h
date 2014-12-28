//
//  QualificationsTableViewController.h
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Qualification.h"
#import "QualificationDetailTableViewController.h"
#import "YearsTableViewController.h"

@interface QualificationsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

// This variable is used to determine whether the user clicked the edit button, or swiped a row
@property (assign) BOOL inSwipeDeleteMode;

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@end
