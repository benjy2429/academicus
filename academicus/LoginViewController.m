//
//  LoginViewController.m
//  academicus
//
//  Created by Luke on 07/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_TINT_COLOUR;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    
    [self.codeLabel setTextColor:[UIColor whiteColor]];
    
    
    NSArray* arrayOfButtons = [NSArray arrayWithObjects: self.numKey0, self.numKey1, self.numKey2, self.numKey3, self.numKey4, self.numKey5, self.numKey6, self.numKey7, self.numKey8, self.numKey9, self.numKeyBlank, self.numKeyDelete, nil];

    for (UIButton* button in arrayOfButtons){
        button.layer.cornerRadius = 30;
        button.layer.borderWidth = 3;
        button.clipsToBounds = YES;
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    }
    
    self.digitsEntered = [[NSMutableString alloc] initWithString:@""];
    self.numDigitsEntered = 0;
}

- (void) closePasscodeScreen {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) changePassword {
    //TODO confirm previous password
    self.titleLabel.text = @"Enter new passcode";
    //TODO get new password
    self.titleLabel.text = @"Confirm passcode";
    //TODO save password
}


- (IBAction)numKeyPressed:(UIButton*)sender {
    switch (sender.tag) {
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


- (void) recordDigit: (int) digitReceived {
    if (digitReceived == -1) {
        if (self.numDigitsEntered > 0) {
            self.numDigitsEntered --;
            [self.digitsEntered setString:[self.digitsEntered substringToIndex:[self.digitsEntered length]-1]];
            [self updateCodeLabel];
        }
    } else {
        self.numDigitsEntered ++;
        [self.digitsEntered appendString: [NSString stringWithFormat:@"%i" , digitReceived]];
        [self updateCodeLabel];
        if (self.numDigitsEntered == 4) {
            [self checkPassword];
        }
    }
    
}


- (void) updateCodeLabel {
    switch (self.numDigitsEntered) {
        case 1: [self.codeLabel setText:@"•  ◦  ◦  ◦"]; break;
        case 2: [self.codeLabel setText:@"•  •  ◦  ◦"]; break;
        case 3: [self.codeLabel setText:@"•  •  •  ◦"]; break;
        case 4: [self.codeLabel setText:@"•  •  •  •"]; break;
        default: [self.codeLabel setText:@"◦  ◦  ◦  ◦"];
    }
}


- (void) checkPassword {
    bool isValid = ([self.digitsEntered isEqualToString: @"1234"]);
    //TODO: check input against a stored password
    if (isValid) {
        [self closePasscodeScreen];
    } else {
        [self shakeAnimation];
        [self.digitsEntered setString: @""];
        self.numDigitsEntered = 0;
        [self updateCodeLabel];
    }
}


- (void) shakeAnimation {
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"position"];
    shake.duration = 0.065;
    shake.repeatCount = 3;
    shake.autoreverses = YES;
    [shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.codeLabel.center.x - 5, self.codeLabel.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:CGPointMake(self.codeLabel.center.x+5, self.codeLabel.center.y)]];
    [self.codeLabel.layer addAnimation:shake forKey: @"position"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
