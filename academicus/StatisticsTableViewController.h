//
//  ProgressTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NumberOfYearsCell.h"
#import "NumberOfAssessmentsCell.h"
#import "HighestGradedAssessmentsCell.h"
#import "HighestRatedAssessmentsCell.h"
#import "AssessmentsOnTargetCell.h"
#import "NumberOfSubjectsCell.h"
#import "PerformanceBySubjectCell.h"
#import "AddMoreDataCell.h"

#import "Qualification.h"
#import "Subject.h"
#import "AssessmentCriteria.h"


//Define the different types of cells that will be displayed as enums
typedef enum StatisticalCells : NSUInteger {
    NumberOfYearsStats,
    NumberOfAssessmentsStats,
    HighestGradedAssessmentsStats,
    HighestRatedAssessmentsStats,
    AssessmentsOnTargetStats,
    NumberOfSubjectsStats,
    PerformanceBySubjectStats,
    AddMoreDataStats
} StatisticalCells;


@interface StatisticsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (strong) NSArray* qualifications;
@property (strong) NSArray* assessments;
@property (strong) NSArray* subjects;

//Set when a qualification is selected
@property (strong) Qualification* selectedQualification;
@property (assign) BOOL isQualificationPickerVisible;

//An array of the cells to display, defined in the order in which to display them
@property (strong)  NSMutableArray* cellsToDisplay;

@end
