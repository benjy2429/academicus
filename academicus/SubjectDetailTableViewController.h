//
//  SubjectDetailTableViewController.h
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"

// Define the maximum for the random function
#define ARC4_RAND_MAX 0x100000000

@class SubjectDetailTableViewController;

// Delegate protocol
@protocol SubjectDetailTableViewControllerDelegate <NSObject>
- (void)SubjectDetailTableViewControllerDidCancel:(SubjectDetailTableViewController*)controller;
- (void)SubjectDetailTableViewController:(SubjectDetailTableViewController*)controller didFinishAddingSubject:(Subject*)subject;
- (void)SubjectDetailTableViewController:(SubjectDetailTableViewController*)controller didFinishEditingSubject:(Subject*)subject;
@end

@interface SubjectDetailTableViewController : UITableViewController <UITextFieldDelegate>

// Properties passed from the previous screen
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (weak) id <SubjectDetailTableViewControllerDelegate> delegate;
@property (strong) Subject *itemToEdit;
@property (assign) float weightingAllocated;

// Buttons and fields
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *weightingField;
@property (weak, nonatomic) IBOutlet UITextField *targetField;
@property (weak, nonatomic) IBOutlet UITextField *teacherNameField;
@property (weak, nonatomic) IBOutlet UITextField *teacherEmailField;

// Colour picker
@property (strong) UIColor *colour;
@property (weak, nonatomic) IBOutlet UIView *colourView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

// Temporary properties for the weighting and target grade
@property (assign) float weighting;
@property (assign) int target;

// Use flags to determine whether the pickers are hidden or visible
@property (assign) BOOL weightingPickerVisible;
@property (assign) BOOL targetPickerVisible;

@end
