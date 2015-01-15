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
#import "SettingsTableViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

NSString* const ManagedObjectContextSaveDidFailNotification = @"ManagedObjectContextSaveDidFailNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coreDataError:) name:ManagedObjectContextSaveDidFailNotification object:nil];
    
    UITabBarController *tabController = (UITabBarController*) self.window.rootViewController;
    
    UINavigationController *navigationController = tabController.viewControllers[0];
    RemindersTableViewController *remindersController = (RemindersTableViewController*) navigationController.topViewController;
    remindersController.managedObjectContext = self.managedObjectContext;
    
    navigationController = tabController.viewControllers[1];
    QualificationsTableViewController *qualificationController = (QualificationsTableViewController*) navigationController.topViewController;
    qualificationController.managedObjectContext = self.managedObjectContext;
    
    navigationController = tabController.viewControllers[3];
    SettingsTableViewController *settingsController = (SettingsTableViewController*) navigationController.topViewController;
    settingsController.managedObjectContext = self.managedObjectContext;
    
    [self setDefaultSettings];
    
    // UI customisation methods
    [[UINavigationBar appearance] setBarTintColor: APP_TINT_COLOUR];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.48f green:0.38f blue:0.57f alpha:0.5f]];
    //[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    //[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor: APP_TINT_COLOUR];
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //If security has been enabled show the login screen
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"passcodeLockEnabled"]) {[self showAuthentication];}
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"DataModel" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}


- (NSString*)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}


- (NSString *)dataStorePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"DataStore.sqlite"];
}

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


- (void)coreDataError:(NSNotification*)notification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We're sorry, there was an error accessing or saving your data. Please report this to the developers." delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:nil];
    alertView.tag = 666;
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 666) {
        abort();
    }
}


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


-(void)setDefaultSettings
{
    NSDictionary *defaults = @{ @"passcodeLockEnabled" : @NO, @"touchIdEnabled" : @NO, @"notificationsEnabled" : @YES };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end
