//
//  LoginViewController.m
//  academicus
//
//  Created by Luke on 07/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialise the keychain item
    self.keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier: @"academicusPasscode" accessGroup:nil];
    
    //Configure the appearance of the view
    self.view.backgroundColor = APP_TINT_COLOUR;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.codeLabel setTextColor:[UIColor whiteColor]];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];

    self.cancelButton.hidden = true; //Hide the cancel button by default
    self.currentState = ConfirmingExistingCodeToLogIn; //Set the defualt state as the login mode
    
    //Configure all the numpad keys
    NSArray* arrayOfButtons = [NSArray arrayWithObjects: self.numKey0, self.numKey1, self.numKey2, self.numKey3, self.numKey4, self.numKey5, self.numKey6, self.numKey7, self.numKey8, self.numKey9, self.numKeyBlank, self.numKeyDelete, nil];
    for (UIButton* button in arrayOfButtons){
        button.layer.cornerRadius = 30;
        button.layer.borderWidth = 2;
        button.clipsToBounds = YES;
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    }
    
    //Initialise the variables for sotring the entered digits
    self.digitsEntered = [[NSMutableString alloc] initWithString:@""];
    self.numDigitsEntered = 0;
}


//Called when the user wants to enter a new passcode
- (void) enterNewPasscode {
    [self resetEnteredDigits]; //Clear any previously entered digits
    self.cancelButton.hidden = false; //The cancel button can be shown
    //Configure the view for entering a new passocde
    self.titleLabel.text = @"Enter New Passcode";
    self.currentState = EnteringNewCode;
}


//Called when the user has entered a new passcode and they need to enter it again to confirm it
- (void) confirmNewPasscode {
    [self resetEnteredDigits]; //Clear any previously entered digits
    self.cancelButton.hidden = false; //The cancel button can be shown
    //Configure the view for confiming a new passcode
    self.titleLabel.text = @"Confirm New Passcode";
    self.currentState = ConfirmingNewCode;
}


//Called when the user wants to disable secuirty and needs to confirm the current passcode
- (void) confirmExistingToDisable {
    [self resetEnteredDigits]; //Clear any previously entered digits
    self.cancelButton.hidden = false; //The cancel button can be shown
    //Configure the view for confirming an existing passcode so that passcode can be turned off
    self.titleLabel.text = @"Confirm Existing Passcode";
    self.currentState = ConfirmingExistingCodeToDisable;
}


//Called when the user wants to change their passcode
- (void) confirmExistingToChange {
    [self resetEnteredDigits]; //Clear any previously entered digits
    self.cancelButton.hidden = false; //The cancel button can be shown
    //Configure the view for confirming an existing passcode so that the code can be changed
    self.titleLabel.text = @"Confirm Existing Passcode";
    self.currentState = ConfirmingExistingCodeToChange;
}


//Clear any previously entered digits
- (void) resetEnteredDigits {
    [self.digitsEntered setString: @""];
    self.numDigitsEntered = 0;
    [self updateCodeLabel];
}


//Al the numpad buttons will call this method which determines what digit was pressed
- (IBAction)numKeyPressed:(UIButton*)sender {
    switch (sender.tag) {
        //Numbers from 0-9
        case 200: [self recordDigit:0]; break;
        case 201: [self recordDigit:1]; break;
        case 202: [self recordDigit:2]; break;
        case 203: [self recordDigit:3]; break;
        case 204: [self recordDigit:4]; break;
        case 205: [self recordDigit:5]; break;
        case 206: [self recordDigit:6]; break;
        case 207: [self recordDigit:7]; break;
        case 208: [self recordDigit:8]; break;
        case 209: [self recordDigit:9]; break;
        case 210: [self recordDigit:-1]; //Delete button
    }
}


//Once a button has been pressed and the digit it represents determined, this method handles the action
- (void) recordDigit: (int) digitReceived {
    //If it was the delete button
    if (digitReceived == -1) {
        //..and at least one digit has been entered previously
        if (self.numDigitsEntered > 0) {
            //We remove the last digit entered
            self.numDigitsEntered --;
            [self.digitsEntered setString:[self.digitsEntered substringToIndex:[self.digitsEntered length]-1]];
            [self updateCodeLabel];
        }
    } else {
        //We store the digit entered and update the count and label
        self.numDigitsEntered ++;
        [self.digitsEntered appendString: [NSString stringWithFormat:@"%i" , digitReceived]];
        [self updateCodeLabel];
        //If this is the fourth digit to be entered, we now have a code which needs to be processed
        if (self.numDigitsEntered == 4) {
            [self checkPasscode];
        }
    }
}


//This method uses the count indicating the number of digits that have been entered to change the label on screen
- (void) updateCodeLabel {
    switch (self.numDigitsEntered) {
        case 1: [self.codeLabel setText:@"● ○ ○ ○"]; break; // 1 digit entered
        case 2: [self.codeLabel setText:@"● ● ○ ○"]; break; // 2 digits entered
        case 3: [self.codeLabel setText:@"● ● ● ○"]; break; // 3 digits entered
        case 4: [self.codeLabel setText:@"● ● ● ●"]; break; // 4 digits entered
        default: [self.codeLabel setText:@"○ ○ ○ ○"]; // No digits entered
    }
}


//This method, called when a 4 digit code has been entered, uses the current view state to perform the appropriate action
- (void) checkPasscode {
    switch (self.currentState) {
        //If confirming the existing code to log in to the system
        case ConfirmingExistingCodeToLogIn: {
            //We obtain the existing code from the keychain item
            NSData* existingCodeData = [self.keychainItem objectForKey:(__bridge id)(kSecValueData)];
            NSString* existingCode = [[NSString alloc] initWithData:existingCodeData encoding:NSUTF8StringEncoding];
            //We compare the existing code to the one that has been entered
            if ([self.digitsEntered isEqualToString: existingCode]) {
                [self dismissViewControllerAnimated:YES completion:nil]; //It matches so we can dismiss the view
            } else {
                [self failedAttempt]; //It doesnt match
            }
        } break;
        //If the user has entered a new passcode
        case EnteringNewCode: {
            self.potentialNewPasscode = [NSString stringWithString: self.digitsEntered]; //We store the entered code
            [self confirmNewPasscode]; //Put the view into the state that makes the user confirm what they have entered
        } break;
        //If the user has entered a code intended the confirm their new desired passcode
        case ConfirmingNewCode: {
            //We check to see if what they entered this time matches what they entered last time
            if ([self.digitsEntered isEqualToString: self.potentialNewPasscode]) {
                //If it does, we store the new passcode
                [self.keychainItem setObject:self.digitsEntered forKey:(__bridge id)(kSecValueData)];
                [self.keychainItem setObject:@"loginCode" forKey:(__bridge id)(kSecAttrAccount)];
                //Then we pass back to the delegate to complete any further tasks
                [self.delegate LoginViewControllerDidChangePasscode:self];
            } else {
                [self failedAttempt]; //It didnt match
            }
        } break;
        //If confirming the existing code so the user can disable secuirty
        case ConfirmingExistingCodeToDisable: {
            //We obtain the existing code from the keychain item
            NSData* existingCodeData = [self.keychainItem objectForKey:(__bridge id)(kSecValueData)];
            NSString* existingCode = [[NSString alloc] initWithData:existingCodeData encoding:NSUTF8StringEncoding];
            //We compare the existing code to the one that has been entered
            if ([self.digitsEntered isEqualToString: existingCode]) {
                [self.keychainItem resetKeychainItem]; //It matches so we delete the passcode from the keychain item
                [self.delegate LoginViewControllerDidAuthenticate:self]; //We pass back to the delegate to complete any further tasks
            } else {
                [self failedAttempt]; //It doesnt match
            }
        } break;
        //If confirming the existing code so the user can change their passcode
        case ConfirmingExistingCodeToChange: {
            //We obtain the existing code from the keychain item
            NSData* existingCodeData = [self.keychainItem objectForKey:(__bridge id)(kSecValueData)];
            NSString* existingCode = [[NSString alloc] initWithData:existingCodeData encoding:NSUTF8StringEncoding];
            //We compare the existing code to the one that has been entered
            if ([self.digitsEntered isEqualToString: existingCode]) {
                [self enterNewPasscode]; //It matches to we can now change to the "enter new passcode" mode to set up a new passcode
            } else {
                [self failedAttempt]; //It doesnt match
            }
        } break;
    }
}


//Called when the cancel button is pressed
- (IBAction)cancelPressed:(id)sender {
    [self.delegate LoginViewControllerDidNotAuthenticate:self]; //Close the window
}


//Called when the entered code didnt match what was expected
- (void) failedAttempt {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); //Vibrate

    //Shake the label
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.065;
    shake.repeatCount = 3;
    shake.autoreverses = YES;
    [shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.codeLabel.center.x - 5, self.codeLabel.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:CGPointMake(self.codeLabel.center.x+5, self.codeLabel.center.y)]];
    [self.codeLabel.layer addAnimation:shake forKey: @"position"];

    [self resetEnteredDigits]; //Clear any previously entered digits
}


@end

