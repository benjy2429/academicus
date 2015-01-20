//
//  YearDetailTableViewController.h
//  academicus
//
//  Created by Ben on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Year.h"

@class YearDetailTableViewController;

// Delegate protocol
@protocol YearDetailTableViewControllerDelegate <NSObject>
- (void)YearDetailTableViewControllerDidCancel:(YearDetailTableViewController*)controller;
- (void)YearDetailTableViewController:(YearDetailTableViewController*)controller didFinishAddingYear:(Year*)year;
- (void)YearDetailTableViewController:(YearDetailTableViewController*)controller didFinishEditingYear:(Year*)year;
@end

@interface YearDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (weak) id <YearDetailTableViewControllerDelegate> delegate;
@property (strong) Year *itemToEdit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

// Temporarily store the dates from the date pickers
@property (strong) NSDate* startDate;
@property (strong) NSDate* endDate;

// Use flags to determine whether the date pickers are hidden or visible
@property (assign) BOOL startDatePickerVisible;
@property (assign) BOOL endDatePickerVisible;

@end
