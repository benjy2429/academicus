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

@interface QualificationDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong) Qualification *itemToEdit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;


@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;


@end
