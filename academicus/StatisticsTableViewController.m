//
//  ProgressTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "StatisticsTableViewController.h"

@interface StatisticsTableViewController ()

@end

@implementation StatisticsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Get the objects from the managed object context
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Qualification" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the sorting preference
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
    // Fetch the data for the table view using CoreData
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // If one portfolio was returned, set it to the property
    self.qualification = [foundObjects objectAtIndex:0]; //TODO set filter qualifications
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier;
    NSString* nibName;
    switch (indexPath.row) {
        case 0: {
            nibName = @"NumberOfYearsCell";
            cellIdentifier = @"numberOfYearsCell";
        } break;
        case 1: {
            nibName = @"NumberOfAssessmentsCell";
            cellIdentifier = @"numberOfAssessmentsCell";
        } break;
        case 2: {
            nibName = @"HighestGradedAssessmentsCell";
            cellIdentifier = @"highestGradedAssessmentsCell";
        } break;
        case 3: {
            nibName = @"HighestRatedAssessmentsCell";
            cellIdentifier = @"highestRatedAssessmentsCell";
        } break;
        case 4: {
            nibName = @"AssessmentsOnTargetCell";
            cellIdentifier = @"assessmentsOnTargetCell";
        } break;
        case 5: {
            nibName = @"PerformanceBySubjectCell";
            cellIdentifier = @"performanceBySubjectCell";
        } break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: return 100; break;
        case 1: return 100; break;
        case 2: return 200; break;
        case 3: return 200; break;
        case 4: return 100; break;
        case 5: return 300; break;
        default: return [super tableView:tableView heightForRowAtIndexPath:indexPath]; break;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            NumberOfYearsCell* specialisedCell = (NumberOfYearsCell*) cell;
            [specialisedCell configureCellWithYears: (int)[self.qualification.years count]];
        } break;
        case 1: {

        } break;
        case 2: {

        } break;
        case 3: {

        } break;
        case 4: {

        } break;
        case 5: {

        } break;
    }
}


@end
