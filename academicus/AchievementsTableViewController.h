//
//  AchievementsTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AchievementDetailTableViewController.h"
#import "Achievement.h"

@interface AchievementsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, AchievementDetailTableViewControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (weak) Portfolio *portfolio;

// This variable is used to determine whether the user clicked the edit button, or swiped a row
@property (assign) BOOL inSwipeDeleteMode;

@end

