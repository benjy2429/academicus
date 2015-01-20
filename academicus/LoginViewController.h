//
//  LoginViewController.h
//  academicus
//
//  Created by Luke on 07/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "KeychainItemWrapper.h"

//The login view is used for a number of different purposes so we define the different states here
typedef enum LoginViewState : NSUInteger {
    ConfirmingExistingCodeToLogIn,
    EnteringNewCode,
    ConfirmingNewCode,
    ConfirmingExistingCodeToDisable,
    ConfirmingExistingCodeToChange
} LoginViewState;

@class LoginViewController;

//Define the methods a delegate must implement
@protocol LoginViewControllerDelegate <NSObject>
- (void)LoginViewControllerDidNotAuthenticate:(LoginViewController*)controller; //Called if an action was cancelled
- (void)LoginViewControllerDidAuthenticate:(LoginViewController*)controller; //Method called when old passcode has been authenticated and passcode can now be turned off
- (void)LoginViewControllerDidChangePasscode:(LoginViewController*)controller; //Method called when either the passcode has been changed or a new passcode has been set up
@end

@interface LoginViewController : UIViewController

@property (assign) int numDigitsEntered; //A count of how many digits have been entered
@property (assign) LoginViewState currentState; //This variable stores what state the view is in

@property (strong) NSMutableString* digitsEntered; //The number of digits entered by the user
@property (strong) NSString* potentialNewPasscode; //Used when changing the passcode to temporarily keep a copy of a new code whilst the user confirms it

@property (strong) KeychainItemWrapper* keychainItem; //This object uses keychain to securely save the passcode
@property (weak) id <LoginViewControllerDelegate> delegate; //Keep track of the delegate

//Elements on the login view xib
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

//Keypad buttons
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

//Sets the view up to allow the user to entere a new passcode
- (void) enterNewPasscode;

//Sets the view up so the user can turn off secuirty
- (void) confirmExistingToDisable;

//Sets the view up so the user can change the current passcode
- (void) confirmExistingToChange;


@end

