//
//  AddQualificationTableViewController.h
//  academicus
//
//  Created by Ben on 19/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Qualification.h"

@class QualificationDetailTableViewController;

// Delegate protocol
@protocol QualificationDetailTableViewControllerDelegate <NSObject>
- (void)QualificationDetailTableViewControllerDidCancel:(QualificationDetailTableViewController*)controller;
- (void)QualificationDetailTableViewController:(QualificationDetailTableViewController*)controller didFinishAddingQualification:(Qualification*)qualification;
- (void)QualificationDetailTableViewController:(QualificationDetailTableViewController*)controller didFinishEditingQualification:(Qualification*)qualification;
@end

@interface QualificationDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak) id <QualificationDetailTableViewControllerDelegate> delegate;
@property (strong) Qualification *itemToEdit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *institutionField;

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;


@end
