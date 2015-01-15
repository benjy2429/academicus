//
//  PortfolioTableViewController.m
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "PortfolioTableViewController.h"

@interface PortfolioTableViewController ()

@end

@implementation PortfolioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Delete the cache to prevent inconsistencies in iOS7
    [NSFetchedResultsController deleteCacheWithName:@"Portfolio"];
    
    // Retrieve the objects for this table view using CoreData
    [self performFetch];
}


- (void)performFetch
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Get the objects from the managed object context
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Portfolio" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the sorting preference
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
    // Fetch the data for the table view using CoreData
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (foundObjects.count == 0) {
        // If a portfolio doesnt exist in the persistent store, create a new one
        self.portfolio = [NSEntityDescription insertNewObjectForEntityForName:@"Portfolio" inManagedObjectContext:self.managedObjectContext];
        
        if (![self.managedObjectContext save:&error]) {
            COREDATA_ERROR(error);
            return;
        }
        
    } else if (foundObjects.count == 1) {
        // If one portfolio was returned, set it to the property
        self.portfolio = [foundObjects objectAtIndex:0];
        
    } else {
        // If more than one portfolio objects were returned, there was an error
        COREDATA_ERROR(error);
        return;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPersonal"]) {
        UINavigationController *navController = segue.destinationViewController;
        PersonalTableViewController *controller = (PersonalTableViewController*) navController.topViewController;
        
        controller.delegate = self;
        controller.itemToEdit = self.portfolio;
        
    } else if ([segue.identifier isEqualToString:@"toHobbies"]) {
        UINavigationController *navController = segue.destinationViewController;
        HobbiesTableViewController *controller = (HobbiesTableViewController*) navController.topViewController;
        
        controller.delegate = self;
        controller.itemToEdit = self.portfolio;
    }
}


#pragma mark - PersonalTableViewControllerDelegate

- (void)personalTableViewControllerDidCancel:(PersonalTableViewController*)controller
{
    // Dismiss the view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)personalTableViewController:(PersonalTableViewController*)controller didFinishSavingPortfolio:(Portfolio*)portfolio
{
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the view
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - HobbiesTableViewControllerDelegate

- (void)hobbiesTableViewControllerDidCancel:(HobbiesTableViewController*)controller
{
    // Dismiss the view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)hobbiesTableViewController:(HobbiesTableViewController*)controller didFinishSavingPortfolio:(Portfolio*)portfolio
{
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
