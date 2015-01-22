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
#import "PerformanceBySubjectCell.h"
#import "Qualification.h"
#import "Subject.h"
#import "AssessmentCriteria.h"


typedef enum StatisticalCells : NSUInteger {
    NumberOfYearsStats,
    NumberOfAssessmentsStats,
    HighestGradedAssessmentsStats,
    HighestRatedAssessmentsStats,
    AssessmentsOnTargetStats,
    PerformanceBySubjectStats
} StatisticalCells;


@interface StatisticsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (strong) NSArray* qualifications;
@property (strong) NSArray* assessments;
@property (strong) NSArray* subjects;


@property (strong) Qualification* selectedQualification;
@property (assign) BOOL qualificationVisible;

@property (strong)  NSMutableArray* cellsToDisplay;

@end
