//
//  HobbiesTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Portfolio.h"

@class HobbiesTableViewController;

@protocol HobbiesTableViewControllerDelegate <NSObject>

- (void)hobbiesTableViewControllerDidCancel:(HobbiesTableViewController*)controller;
- (void)hobbiesTableViewController:(HobbiesTableViewController*)controller didFinishSavingPortfolio:(Portfolio*)qualification;

@end

@interface HobbiesTableViewController : UITableViewController

@property (weak) id <HobbiesTableViewControllerDelegate> delegate;
@property (strong) Portfolio *itemToEdit;

@property (weak, nonatomic) IBOutlet UITextView *hobbiesField;

@end
