//
//  ProgressTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberOfYearsCell.h"
#import "Qualification.h"

@interface StatisticsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (strong) Qualification* qualification;

@end
