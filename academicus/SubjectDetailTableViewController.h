//
//  SubjectDetailTableViewController.h
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"

@class SubjectDetailTableViewController;

@protocol SubjectDetailTableViewControllerDelegate <NSObject>

- (void)SubjectDetailTableViewControllerDidCancel:(SubjectDetailTableViewController*)controller;
- (void)SubjectDetailTableViewController:(SubjectDetailTableViewController*)controller didFinishAddingSubject:(Subject*)subject;
- (void)SubjectDetailTableViewController:(SubjectDetailTableViewController*)controller didFinishEditingSubject:(Subject*)subject;

@end

@interface SubjectDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak) id <SubjectDetailTableViewControllerDelegate> delegate;
@property (assign) float weightingAllocated;

@property (strong) Subject *itemToEdit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *weightingField;
@property (weak, nonatomic) IBOutlet UITextField *targetField;
@property (weak, nonatomic) IBOutlet UITextField *teacherNameField;
@property (weak, nonatomic) IBOutlet UITextField *teacherEmailField;

@property (assign) float weighting;
@property (assign) int target;

@property (strong) UIColor *colour;
@property (weak, nonatomic) IBOutlet UIView *colourView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

// Use flags to determine whether the pickers are hidden or visible
@property (assign) BOOL weightingPickerVisible;
@property (assign) BOOL targetPickerVisible;

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@end
