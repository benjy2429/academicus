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

@property (strong) Subject *itemToEdit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end
