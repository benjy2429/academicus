//
//  AchievementDetailTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Achievement.h"

@class AchievementDetailTableViewController;

// Delegate Protocol
@protocol AchievementDetailTableViewControllerDelegate <NSObject>
- (void)achievementDetailTableViewControllerDidCancel:(AchievementDetailTableViewController*)controller;
- (void)achievementDetailTableViewController:(AchievementDetailTableViewController*)controller didFinishAddingAchievement:(Achievement*)achievement;
- (void)achievementDetailTableViewController:(AchievementDetailTableViewController*)controller didFinishEditingAchievement:(Achievement*)achievement;
@end

@interface AchievementDetailTableViewController : UITableViewController

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (weak) id <AchievementDetailTableViewControllerDelegate> delegate;
@property (strong) Achievement *itemToEdit;

// IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;

// Date Picker
@property (strong) NSDate* dateAchieved;
@property (assign) BOOL datePickerVisible;

@end
