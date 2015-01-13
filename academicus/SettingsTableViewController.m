//
//  SettingsTableViewController.m
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //Adjust the view depending on the passcode setting
    [self configureViewFromPasscode:[[NSUserDefaults standardUserDefaults] boolForKey:@"passcodeLockEnabled"]];
    
    //Toggle the touch id switch depending on the stored setting
    self.touchIdSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"touchIdEnabled"];

}


//Called when the passcode lock switch is toggled
- (IBAction) passcodeLockSwitchChanged:(UISwitch *)sender
{
    sender.on = !sender.on; //First, we cancel the change becuase we havent determined if they are allowed to do it yet
    
    //We load the passcode screen and display it
    LoginViewController* passcodeScreen = [[LoginViewController alloc] init];
    passcodeScreen.delegate = self;
    [self presentViewController: passcodeScreen animated: YES completion:nil];

    //The action to take depending on which way the user toggled (notted since we inverted above)
    if (!sender.on) {
        [passcodeScreen enterNewPasscode]; //If turned on, we establish a new passcode
    } else {
        [passcodeScreen confirmExistingToDisable]; //If turning off we authenticate
    }
}


//Makes changes to the view depending on whether passcode is turned on
- (void) configureViewFromPasscode: (BOOL) passcodeOn
{
    if (passcodeOn) {
        self.passcodeSwitch.on = true; //Turn on the passcode switch
        
        //Enable the ability to change the passcode now one has been set
        self.changePasscodeRow.userInteractionEnabled = true;
        UILabel * changePasscodeLabel = (UILabel*) [self.changePasscodeRow viewWithTag:100];
        changePasscodeLabel.enabled = true;
        
        //If touch id is usable on this device, we allow the user to be able to turn it on
        LAContext *context = [[LAContext alloc] init];
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            self.touchIdRow.userInteractionEnabled = true;
            UILabel * touchIdLabel = (UILabel*) [self.touchIdRow viewWithTag:100];
            touchIdLabel.enabled = true;
            self.touchIdSwitch.enabled = true;
        }
    } else {
        self.passcodeSwitch.on = false; //Turn off the passcode switch
        
        //Disable the ability to change the passcode
        self.changePasscodeRow.userInteractionEnabled = false;
        UILabel * changePasscodeLabel = (UILabel*) [self.changePasscodeRow viewWithTag:100];
        changePasscodeLabel.enabled = false;
        
        //Turn touch id off
        self.touchIdSwitch.on = false;
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"touchIdEnabled"];
        
        //Disable the ability to use touch id
        self.touchIdRow.userInteractionEnabled = false;
        UILabel * touchIdLabel = (UILabel*) [self.touchIdRow viewWithTag:100];
        touchIdLabel.enabled = false;
        self.touchIdSwitch.enabled = false;
    }
}


//Called if an action on the passcode screen was cancelled
- (void)LoginViewControllerDidNotAuthenticate:(LoginViewController*)controller
{
    //Close passcode screen
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Method called when old passcode has been authenticated and passcode can now be turned off
- (void)LoginViewControllerDidAuthenticate:(LoginViewController*)controller
{
    //Change the passcode setting to recongise that secuirty is off
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"passcodeLockEnabled"];
    
    //Adjust the view depending on the passcode setting
    [self configureViewFromPasscode:false];

    //Close passcode screen
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Method called when either the passcode has been changed or a new passcode has been set up
- (void)LoginViewControllerDidChangePasscode:(LoginViewController*)controller
{
    //Change the passcode setting to recognise that security is on
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"passcodeLockEnabled"];
    
    //Adjust the view depending on the passcode setting
    [self configureViewFromPasscode:true];
    
    //Close passcode screen
    [self dismissViewControllerAnimated:YES completion:nil];
}


//When the touch id switch is toggled
- (IBAction)touchIdSwitchChanged:(UISwitch* )sender
{
    //Change the touch id setting
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"touchIdEnabled"];
}


//Triggered when the change passcode row is clicked
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 1) {
        //Load and display the login screen
        LoginViewController* passcodeScreen = [[LoginViewController alloc] init];
        passcodeScreen.delegate = self;
        [self presentViewController: passcodeScreen animated: YES completion:nil];
        
        //Tell the passcode screen that we want to change the passcode
        [passcodeScreen confirmExistingToChange];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

