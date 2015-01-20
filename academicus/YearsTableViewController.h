//
//  YearsTableViewController.h
//  academicus
//
//  Created by Ben on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Qualification.h"
#import "Year.h"
#import "YearDetailTableViewController.h"
#import "SubjectsTableViewController.h"

@interface YearsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, YearDetailTableViewControllerDelegate>

@property (weak) Qualification *qualification;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

// This variable is used to determine whether the user clicked the edit button, or swiped a row
@property (assign) BOOL inSwipeDeleteMode;

@end
