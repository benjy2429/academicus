//
//  ProgressTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "StatisticsTableViewController.h"

@implementation StatisticsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform an initial fetch to get qualifications for the picker
    [self performFetch];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Fetch the data when the view loads to ensure it is up to date
    [self performFetch];
    [self loadAssessments];
    
    // Reload the date picker options
    UIPickerView *picker = (UIPickerView *)[self.tableView viewWithTag:500];
    [picker reloadAllComponents];
    
    // Reload the table to update the cells
    [self.tableView reloadData];
    
    // Update the selected qualification label incase the qualification name changed
    UILabel *qualificationLabel = (UILabel*) [self.tableView viewWithTag:100];
    qualificationLabel.text = (self.selectedQualification) ? self.selectedQualification.name : @"Select Qualification";
}


- (void)performFetch {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Get the objects from the managed object context
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Qualification" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the sorting preference
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
    // Fetch the data for the table view using CoreData
    NSError *error;
    self.qualifications = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error]; //TODO should we do something with this error or make it nil?
    
    // Make sure there were no errors fetching the data
    if (error != nil) {
        COREDATA_ERROR(error);
        return;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = (self.selectedQualification != nil) ? (int)[self.cellsToDisplay count]+1 : 1;
    return (self.qualificationVisible) ? rows+1 : rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int arrayPositionToUse = (int) indexPath.row - 1;
    if (indexPath.row == 0) {
        NSString *identifier = @"selectQualificationCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    if (self.qualificationVisible ) {
        if (indexPath.row == 1) {
            NSString *identifier = @"qualificationPickerCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            // Create a new cell
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                CGRect frame = cell.frame;
                frame.size.width = [UIScreen mainScreen].bounds.size.width;
                frame.size.height = 150;
                UIPickerView *qualifciationPicker = [[UIPickerView alloc] initWithFrame:frame];
                [qualifciationPicker setDataSource:self];
                [qualifciationPicker setDelegate:self];
                [qualifciationPicker setTag:500];
                qualifciationPicker.showsSelectionIndicator = YES;
                [cell.contentView addSubview:qualifciationPicker];
            }
            
            return cell;
        }
        
        arrayPositionToUse--;
    }
    
        NSString* cellIdentifier;
        NSString* nibName;
        switch ((StatisticalCells) [self.cellsToDisplay[arrayPositionToUse] integerValue]) {
            case NumberOfYearsStats: {
                nibName = @"NumberOfYearsCell";
                cellIdentifier = @"numberOfYearsCell";
            } break;
            case NumberOfAssessmentsStats: {
                nibName = @"NumberOfAssessmentsCell";
                cellIdentifier = @"numberOfAssessmentsCell";
            } break;
            case HighestGradedAssessmentsStats: {
                nibName = @"HighestGradedAssessmentsCell";
                cellIdentifier = @"highestGradedAssessmentsCell";
            } break;
            case HighestRatedAssessmentsStats: {
                nibName = @"HighestRatedAssessmentsCell";
                cellIdentifier = @"highestRatedAssessmentsCell";
            } break;
            case AssessmentsOnTargetStats: {
                nibName = @"AssessmentsOnTargetCell";
                cellIdentifier = @"assessmentsOnTargetCell";
            } break;
            case PerformanceBySubjectStats: {
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
    if (indexPath.row == 0) {return 50;}
    int arrayIndexToUse = (int) indexPath.row - 1;
    if (self.qualificationVisible) {
        if (indexPath.row == 1) {return 150;}
        arrayIndexToUse --;
    }
    switch ((StatisticalCells) [self.cellsToDisplay[arrayIndexToUse] integerValue]) {
        case NumberOfYearsStats: return 100; break;
        case NumberOfAssessmentsStats: return 100; break;
        case HighestGradedAssessmentsStats: return 200; break;
        case HighestRatedAssessmentsStats: return 200; break;
        case AssessmentsOnTargetStats: return 100; break;
        case PerformanceBySubjectStats: return 300; break;
        default: return [super tableView:tableView heightForRowAtIndexPath:indexPath]; break;
    }
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        cell.userInteractionEnabled = ([self.qualifications count] > 0) ? YES : NO;
        UILabel *qualificationLabel = (UILabel*) [cell viewWithTag:100];
        qualificationLabel.enabled = ([self.qualifications count] > 0) ? YES : NO;
    } else if (!(indexPath.row == 1 && self.qualificationVisible)){
    
        int arrayIndexToUse = (int) indexPath.row - 1;
        if (self.qualificationVisible) {arrayIndexToUse --;}

        switch ((StatisticalCells) [self.cellsToDisplay[arrayIndexToUse] integerValue]) {
            case NumberOfYearsStats: {
                NumberOfYearsCell* specialisedCell = (NumberOfYearsCell*) cell;
                [specialisedCell configureCellWithYears: (int)[self.selectedQualification.years count]];
            } break;
            case NumberOfAssessmentsStats: {
                NumberOfAssessmentsCell* specialisedCell = (NumberOfAssessmentsCell*) cell;
                [specialisedCell configureCellWithAssessments: (int)[self.assessments count]];
            } break;
            case HighestGradedAssessmentsStats: {
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"finalGrade" ascending:NO];
                NSArray* gradeOrderedAssessments = [self.assessments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                HighestGradedAssessmentsCell* specialisedCell = (HighestGradedAssessmentsCell*) cell;
                [specialisedCell configureCellWithHighestGrades:gradeOrderedAssessments];

            } break;
            case HighestRatedAssessmentsStats: {
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
                NSArray* ratingOrderedAssessments = [self.assessments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                HighestRatedAssessmentsCell* specialisedCell = (HighestRatedAssessmentsCell*) cell;
                [specialisedCell configureCellWithHighestRatings:ratingOrderedAssessments];
            } break;
            case AssessmentsOnTargetStats:  {
                AssessmentsOnTargetCell* specialisedCell = (AssessmentsOnTargetCell*) cell;
                int assessmentsOnTarget = 0;
                int assessmentsGraded = 0;
                for (AssessmentCriteria* assessment in self.assessments) {
                    if ([assessment.finalGrade boolValue]) {
                        assessmentsGraded++;
                        if ([assessment.finalGrade floatValue] >= [assessment.subject.targetGrade floatValue]) {
                            assessmentsOnTarget++;
                        }
                    }
                }
                [specialisedCell configureCellWithMetTarget:assessmentsOnTarget gradedAssessments: assessmentsGraded];
            } break;
            case PerformanceBySubjectStats: {
                PerformanceBySubjectCell* specialisedCell = (PerformanceBySubjectCell*) cell;
                //[specialisedCell configureCellWithAssessments]
            } break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If the cell is the qualification picker cell
    if (indexPath.row == 0) {
        
        // Toggle the visibility of the picker cell
        if (!self.qualificationVisible) {
            [self showQualificaitonPicker];
        } else {
            [self loadAssessments];
            [self hideQualificaitonPicker];
        }

    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showQualificaitonPicker
{
    // Set the visible flag to true
    self.qualificationVisible = YES;
    
    [self.tableView reloadData];
}


- (void)hideQualificaitonPicker
{
    // Set the visible flag to false
    self.qualificationVisible = NO;
    
    [self.tableView reloadData];
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.qualifications count] + 1;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {return @"Select Qualification";}
    Qualification* qualificaiton = [self.qualifications objectAtIndex:row-1];
    return qualificaiton.name;
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSIndexPath *indexPathQualificationPicker = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *qualificationPickerCell = [self.tableView cellForRowAtIndexPath:indexPathQualificationPicker];
    UILabel *qualificationLabel = (UILabel*) [qualificationPickerCell viewWithTag:100];
    if (row == 0) {
        qualificationLabel.text = @"Select Qualification";
        self.selectedQualification = nil;
    } else {
        Qualification* qualification = (Qualification*)[self.qualifications objectAtIndex:row-1];
        qualificationLabel.text = qualification.name;
        self.selectedQualification = qualification;
    }
}


- (void) loadAssessments
{
    self.cellsToDisplay = nil;
    if (self.selectedQualification != nil) {
        self.cellsToDisplay = [[NSMutableArray alloc] initWithObjects: @(NumberOfYearsStats) ,nil];
        
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"AssessmentCriteria" inManagedObjectContext:self.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subject.year.qualification == %@", self.selectedQualification];
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];

        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Fetch the data for the table view using CoreData
        NSError *error;
        self.assessments = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error]; //TODO should we do something with this error or make it nil?
        
        if ([self.assessments count] > 0) {
            [self.cellsToDisplay addObject: @(NumberOfAssessmentsStats)];
            [self.cellsToDisplay addObject: @(HighestGradedAssessmentsStats)];
            [self.cellsToDisplay addObject: @(HighestRatedAssessmentsStats)];
            [self.cellsToDisplay addObject: @(AssessmentsOnTargetStats)];
            [self.cellsToDisplay addObject: @(PerformanceBySubjectStats)];
        } else {
            //TODO add a "you should add some grades to get stats"
        }
    }
}


@end
