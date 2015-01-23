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
    
    // Fetch data when the view loads to ensure it is up to date
    [self performFetch];
    [self loadAssessments];
    [self loadSubjects];
    
    // Reload the date picker options
    UIPickerView *picker = (UIPickerView *)[self.tableView viewWithTag:500];
    [picker reloadAllComponents];
    
    // If the selected qualification was not returned, clear the selected qualification
    if (![self.qualifications containsObject:self.selectedQualification]) {
        self.selectedQualification = nil;
        [picker selectRow:0 inComponent:0 animated:NO];
    }
    
    // Reload the table to update the cells
    [self.tableView reloadData];
    
    // Update the selected qualification label incase the qualification name changed
    UILabel *qualificationLabel = (UILabel*) [self.tableView viewWithTag:100];
    qualificationLabel.text = (self.selectedQualification) ? self.selectedQualification.name : @"Select Qualification";
}


//Fetches an array of qualifications
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
    self.qualifications = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
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
    //If a qualification has been selected, then there are as many rows as there are statistic cells to display plus the picker, otherwise just one for the picker
    int rows = (self.selectedQualification != nil) ? (int)[self.cellsToDisplay count]+1 : 1;
    //If the picker is shown, add one row
    return (self.isQualificationPickerVisible) ? rows+1 : rows;
}


//Create the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //If the current cell is the first row
    if (indexPath.row == 0) {
        //Return the select qualification semm
        NSString *identifier = @"selectQualificationCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    
    //If the picker should be visible and this is the second row, return the qualification picker cell
    if (self.isQualificationPickerVisible && indexPath.row == 1) {
        NSString *identifier = @"qualificationPickerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        // Create a new cell
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //Create the picker and put it in the cell
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
    
    
    //If the function hasnt already been return, we need to display one of the stats cells
    NSString* cellIdentifier;
    NSString* nibName;
    
    //Set the variable used to get the cell from the array of cells to display
    int arrayPositionToUse = (!self.isQualificationPickerVisible) ? (int) (indexPath.row - 1) : (int) (indexPath.row - 2);
    
    //We get the enum value representing the cell to display from the array of cells to display and define a nibname and cell identifier
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
            
        case NumberOfSubjectsStats: {
            nibName = @"NumberOfSubjectsCell";
            cellIdentifier = @"numberOfSubjectsCell";
        } break;
            
        case PerformanceBySubjectStats: {
            nibName = @"PerformanceBySubjectCell";
            cellIdentifier = @"performanceBySubjectCell";
        } break;
            
        case AddMoreDataStats: {
            nibName = @"AddMoreDataCell";
            cellIdentifier = @"addMoreDataCell";
        } break;
    }
    
    //Using the nibname and cell identifier we can determine the correct cell to return
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    //None of these cells should be selectable
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}


//Determine the height of the current cell
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //The first row, the select qualification cell
    if (indexPath.row == 0) {return 50;}
    
    //If the qualification picker should be shown and the current indexpath is the secon row
    if (self.isQualificationPickerVisible && indexPath.row == 1) {return 150;}

    //Set the variable used to get the cell from the array of cells to display
    int arrayIndexToUse = (!self.isQualificationPickerVisible) ? (int) (indexPath.row - 1) : (int) (indexPath.row - 2);
    
    //We get the enum value representing the cell to display from the array of cells to display and return the correct size for that cell
    switch ((StatisticalCells) [self.cellsToDisplay[arrayIndexToUse] integerValue]) {
        case NumberOfYearsStats: return 150; break;
        case NumberOfAssessmentsStats: return 150; break;
        case HighestGradedAssessmentsStats: return 250; break;
        case HighestRatedAssessmentsStats: return 250; break;
        case AssessmentsOnTargetStats: return 150; break;
        case NumberOfSubjectsStats: return 150; break;
        case PerformanceBySubjectStats: return 400; break;
        case AddMoreDataStats: return 150; break;
        default: return [super tableView:tableView heightForRowAtIndexPath:indexPath]; break;
    }
}


//Called when a cell is about to be displayed
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //If the cell is the first row
    if (indexPath.row == 0) {
        //Enable user interaction only if there is at least one qualification
        cell.userInteractionEnabled = ([self.qualifications count] > 0) ? YES : NO;
        UILabel *qualificationLabel = (UILabel*) [cell viewWithTag:100];
        qualificationLabel.enabled = ([self.qualifications count] > 0) ? YES : NO;
        
    } else if (!(indexPath.row == 1 && self.isQualificationPickerVisible)){
        //We dont need to do anything for the picker cell, so providing the current cell is not that cell, we can continue
        
        //Set the variable used to get the cell from the array of cells to display
        int arrayIndexToUse = (!self.isQualificationPickerVisible) ? (int) (indexPath.row - 1) : (int) (indexPath.row - 2);

        //We get the enum value representing the cell to display from the array of cells to display and perform the appropriate tasks
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
                //Order the list of assesments by their final grades
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"finalGrade" ascending:NO];
                NSArray* gradeOrderedAssessments = [self.assessments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                HighestGradedAssessmentsCell* specialisedCell = (HighestGradedAssessmentsCell*) cell;
                [specialisedCell configureCellWithHighestGrades:gradeOrderedAssessments];
            } break;
                
            case HighestRatedAssessmentsStats: {
                //Order the list of assessments by their ratings
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
                NSArray* ratingOrderedAssessments = [self.assessments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                HighestRatedAssessmentsCell* specialisedCell = (HighestRatedAssessmentsCell*) cell;
                [specialisedCell configureCellWithHighestRatings:ratingOrderedAssessments];
            } break;
                
            case AssessmentsOnTargetStats:  {
                //Calculate the number of assessments that have been graded and also how many of those met the target
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
                
            case NumberOfSubjectsStats: {
                NumberOfSubjectsCell* specialisedCell = (NumberOfSubjectsCell*) cell;
                [specialisedCell configureCellWithSubjects: (int)[self.subjects count]];
            } break;
                
            case PerformanceBySubjectStats: {
                PerformanceBySubjectCell* specialisedCell = (PerformanceBySubjectCell*) cell;
                [specialisedCell configureCellWithSubjects: self.subjects];
            } break;
                
            case AddMoreDataStats: break;
        }
    }
}


//Called when a row is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If the cell is the qualification picker cell
    if (indexPath.row == 0) {
        // Toggle the visibility of the picker cell
        if (!self.isQualificationPickerVisible) {
            [self showQualificaitonPicker];
        } else {
            //If the picker is being hidden we can get the latest data based on the option they select
            [self loadAssessments];
            [self loadSubjects];
            [self hideQualificaitonPicker];
        }

    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Qualification Picker

//Called whent he qualification picker should be shown
- (void)showQualificaitonPicker {
    // Set the visible flag to true
    self.isQualificationPickerVisible = YES;
    
    [self.tableView reloadData];
}


//Called when the qualification picker should be hidden
- (void)hideQualificaitonPicker {
    // Set the visible flag to false
    self.isQualificationPickerVisible = NO;
    
    [self.tableView reloadData];
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.qualifications count] + 1;
}


//The options in the picker are defined from the qualification names
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {return @"Select Qualification";}
    Qualification* qualificaiton = [self.qualifications objectAtIndex:row-1];
    return qualificaiton.name;
}


//Called when the user selects an option from the picker
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSIndexPath *indexPathQualificationPicker = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *qualificationPickerCell = [self.tableView cellForRowAtIndexPath:indexPathQualificationPicker];
    UILabel *qualificationLabel = (UILabel*) [qualificationPickerCell viewWithTag:100];

    //If they selected the placeholder row, we deselect any previously selected option
    if (row == 0) {
        qualificationLabel.text = @"Select Qualification";
        self.selectedQualification = nil;
    } else {
        //Otherwise, we change the qualification label text based on the option selected in the picker
        Qualification* qualification = (Qualification*)[self.qualifications objectAtIndex:row-1];
        qualificationLabel.text = qualification.name;
        //We also update the selected qualification variable
        self.selectedQualification = qualification;
    }
}


#pragma mark - Load Data

//Loads all the assessments for the currently select qualification and updates the list of cells to display accordingly
- (void) loadAssessments {
    //Start be clearing the list of cells to display
    self.cellsToDisplay = nil;
    
    //Continue only if a qualification has been selected
    if (self.selectedQualification != nil) {
        //We can add the number of years statistic cell
        self.cellsToDisplay = [[NSMutableArray alloc] initWithObjects: @(NumberOfYearsStats) ,nil];
        
        //Get all the assessments for the selected qualification and sort the list by the assessment name
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"AssessmentCriteria" inManagedObjectContext:self.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subject.year.qualification == %@", self.selectedQualification];
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Fetch the data for the table view using CoreData
        NSError *error;
        self.assessments = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        // Make sure there were no errors fetching the data
        if (error != nil) {
            COREDATA_ERROR(error);
            return;
        }
        
        //If the assessment count is greater than 1
        if ([self.assessments count] > 0) {
            //Add these cells
            [self.cellsToDisplay addObject: @(NumberOfAssessmentsStats)];
            [self.cellsToDisplay addObject: @(HighestGradedAssessmentsStats)];
            [self.cellsToDisplay addObject: @(HighestRatedAssessmentsStats)];
            [self.cellsToDisplay addObject: @(AssessmentsOnTargetStats)];
            [self.cellsToDisplay addObject: @(NumberOfSubjectsStats)];
            [self.cellsToDisplay addObject: @(PerformanceBySubjectStats)];
        } else {
            [self.cellsToDisplay addObject: @(AddMoreDataStats)];
        }
    }
}


//Load all the subjects for the currently selected qualification
- (void) loadSubjects {
    //Continue only if a qualification has been selected
    if (self.selectedQualification != nil) {
        //Get al the subjects for the selected qualification and sort the list by the subject name
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year.qualification == %@", self.selectedQualification];
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Fetch the data for the table view using CoreData
        NSError *error;
        self.subjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        // Make sure there were no errors fetching the data
        if (error != nil) {
            COREDATA_ERROR(error);
            return;
        }
    }
}


@end

