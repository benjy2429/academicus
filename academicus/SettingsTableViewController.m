//
//  SettingsTableViewController.m
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "SettingsTableViewController.h"

@implementation SettingsTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //Toggle the notifications switch depending on the stored setting
    self.notificationsSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"notificationsEnabled"];
    
    //Adjust the view depending on the passcode setting
    [self configureViewFromPasscode:[[NSUserDefaults standardUserDefaults] boolForKey:@"passcodeLockEnabled"]];
    
    //Toggle the touch id switch depending on the stored setting
    self.touchIdSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"touchIdEnabled"];
    
    //Toggle the save photos switch depending on the stored setting
    self.savePhotosSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoSavePhotos"];
}


#pragma mark - Notifications

//When the notifications toggle is changed
- (IBAction)notificationSwitchChanged:(UISwitch *)sender {
    //If turned on
    if (sender.on) {
        // Fetch assessments
        [self performFetch];
        
        for (AssessmentCriteria *assessment in self.assessments) {
            [assessment createDeadlineReminder];
        }
    } else {
        // Get all the notifications and delete the deadline reminders
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *notification in notifications) {
            NSDictionary *userInfo = notification.userInfo;
            
            if ([[userInfo valueForKey:@"isDeadlineReminder"] boolValue]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
    
    // Set the NSUserDefaults setting to store the change
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"notificationsEnabled"];
}


//Fetch all assessments without a grade so that reminder notifications can be set
- (void)performFetch {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Get the objects from the managed object context
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AssessmentCriteria" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the sorting preference
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deadline" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Set the predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"hasGrade == false"];
    [fetchRequest setPredicate:predicate];
    
    // Fetch the data for the table view using CoreData
    NSError *error;
    self.assessments = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Make sure there were no errors fetching the data
    if (error != nil) {
        COREDATA_ERROR(error);
        return;
    }
}


#pragma mark - Security

//Called when the passcode lock switch is toggled
- (IBAction) passcodeLockSwitchChanged:(UISwitch *)sender {
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


//Makes changes to the view depending on whether passcode toggle is turned on
- (void) configureViewFromPasscode: (BOOL) passcodeOn {
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
- (void)LoginViewControllerDidNotAuthenticate:(LoginViewController*)controller {
    //Close passcode screen
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Method called when old passcode has been authenticated and passcode can now be turned off
- (void)LoginViewControllerDidAuthenticate:(LoginViewController*)controller {
    //Change the passcode setting to recongise that secuirty is off
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"passcodeLockEnabled"];
    
    //Adjust the view depending on the passcode setting
    [self configureViewFromPasscode:false];

    //Close passcode screen
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Method called when either the passcode has been changed or a new passcode has been set up
- (void)LoginViewControllerDidChangePasscode:(LoginViewController*)controller {
    //Change the passcode setting to recognise that security is on
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"passcodeLockEnabled"];
    
    //Adjust the view depending on the passcode setting
    [self configureViewFromPasscode:true];
    
    //Close passcode screen
    [self dismissViewControllerAnimated:YES completion:nil];
}


//When the touch id switch is toggled
- (IBAction)touchIdSwitchChanged:(UISwitch* )sender {
    //Change the touch id setting
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"touchIdEnabled"];
}


#pragma mark - iCloud

//Called when the iCloud toggle is changed
- (IBAction)iCloudBackupSwitchChanged:(UISwitch *)sender {
    //Feature not yet implemented to display a notificaiton to the user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon!" message:@"The iCloud backup feature is coming soon" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [sender setOn:NO animated:YES];
}


#pragma mark - Photos

//When the save photos switch is toggled
- (IBAction)savePhotosSwitchChanged:(UISwitch* )sender {
    //Change the save photos setting
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"autoSavePhotos"];
}


#pragma mark - Table View

//Triggered when the change passcode row is clicked
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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


@end

