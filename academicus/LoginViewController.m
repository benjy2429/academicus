//
//  LoginViewController.m
//  academicus
//
//  Created by Luke on 07/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_TINT_COLOUR;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    
    NSArray* arrayOfButtons = [NSArray arrayWithObjects: self.numKey0, self.numKey1, self.numKey2, self.numKey3, self.numKey4, self.numKey5, self.numKey6, self.numKey7, self.numKey8, self.numKey9, self.numKeyBlank, self.numKeyDelete, nil];

    for (UIButton* button in arrayOfButtons){
        button.layer.cornerRadius = 30;
        button.layer.borderWidth = 3;
        button.clipsToBounds = YES;
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    }


    /*
    self.numKey1.layer.cornerRadius = 30;
    self.numKey1.layer.borderWidth = 3;
    self.numKey1.clipsToBounds = YES;
    self.numKey1.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.numKey1 setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];*/
}

- (void) displayPasscode: (bool)passwordNeeded {
    if (passwordNeeded) {
        [self displayPasswordScreen];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) displayPasswordScreen {
    //UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[button addTarget:self action:@selector(checkPassword) forControlEvents: UIControlEventTouchUpInside];
    //[button setTitle:@"enter" forState: UIControlStateNormal];
    //button.frame = CGRectMake(10,100,100,50);
    //[self.view addSubview:button];
    //TODO: design and show passcode scren
}


- (IBAction)numKeyPressed:(UIButton*)sender {
    if (sender.tag == 201) {
        [self checkPassword]; //TODO: recieve four keypresses and then check
    }
}


- (void) checkPassword {
    bool isValid = true;
    //TODO: check input against some password
    if (isValid) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //TODO: reset login and display error
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
