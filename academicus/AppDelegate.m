//
//  AppDelegate.m
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "AppDelegate.h"
#import "QualificationsTableViewController.h"
#import "RemindersTableViewController.h"
#import "PortfolioTableViewController.h"
#import "SettingsTableViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

NSString* const ManagedObjectContextSaveDidFailNotification = @"ManagedObjectContextSaveDidFailNotification";

@implementation AppDelegate


//Called when the application starts
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Add a listener to respond to core data error notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coreDataError:) name:ManagedObjectContextSaveDidFailNotification object:nil];
    
    //Pass the managed object context to each of the top views for each tab
    UITabBarController *tabController = (UITabBarController*) self.window.rootViewController;
    
    UINavigationController *navigationController = tabController.viewControllers[0];
    RemindersTableViewController *remindersController = (RemindersTableViewController*) navigationController.topViewController;
    remindersController.managedObjectContext = self.managedObjectContext;
    
    navigationController = tabController.viewControllers[1];
    QualificationsTableViewController *qualificationController = (QualificationsTableViewController*) navigationController.topViewController;
    qualificationController.managedObjectContext = self.managedObjectContext;
    
    navigationController = tabController.viewControllers[2];
    PortfolioTableViewController *portfolioController = (PortfolioTableViewController*) navigationController.topViewController;
    portfolioController.managedObjectContext = self.managedObjectContext;
    
    navigationController = tabController.viewControllers[3];
    SettingsTableViewController *settingsController = (SettingsTableViewController*) navigationController.topViewController;
    settingsController.managedObjectContext = self.managedObjectContext;
    
    //Initialises the NSUserDefaults
    [self setDefaultSettings];
    
    // UI customisation methods
    [[UINavigationBar appearance] setBarTintColor: APP_TINT_COLOUR];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor: APP_TINT_COLOUR];
    [[UISearchBar appearance] setBarTintColor: APP_TINT_COLOUR];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // iOS 8 local notification registration
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
#endif
    
    //If security has been enabled show the login screen
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"passcodeLockEnabled"]) {[self showAuthentication];}
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //If security has been enabled show the login screen
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"passcodeLockEnabled"]) {[self showAuthentication];}
    //Clear the badge number
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //Clear the badge number
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {}


//If a local notification is received when the app is active or open, display an alert
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


//This method defines the default values of all settings
-(void)setDefaultSettings
{
    NSDictionary *defaults = @{ @"passcodeLockEnabled" : @NO, @"touchIdEnabled" : @NO, @"notificationsEnabled" : @YES, @"autoSavePhotos" : @YES};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}


#pragma mark - Core Data Methods
//Custom getter to generate the NSManagedObjectModel
- (NSManagedObjectModel*)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"DataModel" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}


//Returns a string to the path of the documents directory
- (NSString*)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}


//Returns the path to the datastore file
- (NSString *)dataStorePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"DataStore.sqlite"];
}


//Custom getter to generate a NSPersistentStoreCoordinator
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeURL = [NSURL fileURLWithPath:[self dataStorePath]];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Error adding persistent store %@, %@", error, [error userInfo]);
            COREDATA_ERROR(error);
        }
    }
    return _persistentStoreCoordinator;
}


//Custom getter to generate the NSManagedObjectContext
- (NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}


//Displays an alert view if a fatal core data was recevied
- (void)coreDataError:(NSNotification*)notification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We're sorry, there was an error accessing or saving your data. Please report this to the developers." delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:nil];
    alertView.tag = 666;
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}


//Terminates the app if the user dismisses the fatal core data error alert
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 666) {
        abort();
    }
}


#pragma mark - Authentication

//Called when the login screen should be displayed
- (void) showAuthentication
{
    [self.window makeKeyAndVisible];
    
    //First we check that a login screen isnt already being displayed
    if (!(self.loginScreen.isViewLoaded && self.loginScreen.view.window)) {
        //We display the view ontop of whatever is currently being displayed
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController){
            topController = topController.presentedViewController;
        }
        self.loginScreen = [[LoginViewController alloc] init];
        [topController presentViewController: self.loginScreen animated: NO completion:nil]; //We dont animate as we want it to appear asap
    }
    
    //If touch id has been enabled we give the user the opportunity to use it
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"touchIdEnabled"]) {
        LAContext *context = [[LAContext alloc] init];
        NSError *error = nil;
        //First we check that touch id can be used, if they can't or any errors occur, we default to passcode
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            //If touch id is available for use the touch id interface will be shown
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:@"Authenticate to unlock Academicus"
                              reply:^(BOOL success, NSError *error) {
                                  //If they successfully authenticate we dismiss the login screen
                                  if (success) {
                                      dispatch_async(dispatch_get_main_queue(), ^ {
                                          [self.loginScreen dismissViewControllerAnimated:YES completion:nil];
                                      });
                                  }
                              }];
        }
    }
}


@end

