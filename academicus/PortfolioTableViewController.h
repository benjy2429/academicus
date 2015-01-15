//
//  PortfolioTableViewController.h
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalTableViewController.h"

@interface PortfolioTableViewController : UITableViewController <PersonalTableViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (strong) Portfolio *portfolio;

@end
