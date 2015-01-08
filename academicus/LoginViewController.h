//
//  LoginViewController.h
//  academicus
//
//  Created by Luke on 07/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UIButton *numKey1;
@property (weak, nonatomic) IBOutlet UIButton *numKey2;
@property (weak, nonatomic) IBOutlet UIButton *numKey3;
@property (weak, nonatomic) IBOutlet UIButton *numKey4;
@property (weak, nonatomic) IBOutlet UIButton *numKey5;
@property (weak, nonatomic) IBOutlet UIButton *numKey6;
@property (weak, nonatomic) IBOutlet UIButton *numKey7;
@property (weak, nonatomic) IBOutlet UIButton *numKey8;
@property (weak, nonatomic) IBOutlet UIButton *numKey9;
@property (weak, nonatomic) IBOutlet UIButton *numKeyBlank;
@property (weak, nonatomic) IBOutlet UIButton *numKey0;
@property (weak, nonatomic) IBOutlet UIButton *numKeyDelete;

@property (assign) int numDigitsEntered;
@property (strong) NSMutableString* digitsEntered;

- (void) closePasscodeScreen;

@end