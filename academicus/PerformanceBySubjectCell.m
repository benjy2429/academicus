//
//  PerformanceBySubjectCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "PerformanceBySubjectCell.h"

//Cell constants
const float AXIS_THICKNESS = 5;
const float SUBJECT_PERFORMANCE_DURATION = 1.0f;
const float COLUMN_ANIMATION_DELAY = 0.3f;

@implementation PerformanceBySubjectCell


- (void)awakeFromNib {}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//Given an array of subjects, draw an interactive graph
- (void) configureCellWithSubjects: (NSArray*) subjects {
    //Reset the cell
    self.selectedSubjectGrade.hidden = YES;
    self.selectedSubjectColourBlock.hidden = YES;
    self.selectedSubjectName.hidden = YES;
    [[self.performanceGraphView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    //Initialise the cell by determining the graph origin and size
    self.subjects = subjects;
    self.graphOriginX = 0.0f;
    self.graphOriginY = self.performanceGraphView.frame.size.height;
    self.graphWidth = [UIScreen mainScreen].bounds.size.width - 55;
    self.graphHeight = self.performanceGraphView.frame.size.height;
    
    //Determine the width of each column
    if ([self.subjects count] > 2) {
        self.columnWidth = self.graphWidth / (float)[self.subjects count];
    } else {
        self.columnWidth = self.graphWidth / 2.0f;
    }
    
    //Draw a column for each subject
    int currentIndex = 0;
    for (Subject* subject in self.subjects) {
        [self drawColumnWithSubject:subject subjectIndex:currentIndex]; //Pass the subject and its position in the array
        currentIndex++;
    }
    
    //Draw the graph axis
    [self drawAxis];
    
    //Providing ther is at least 1 subject, show the key for the first subject in the aray
    if ([self.subjects count] > 0) {
        [self showStatsForSubject:[self.subjects objectAtIndex:0]];
    }
}


//Draws the graph axis
- (void) drawAxis {
    //Create a view to become the y axis
    UIView *yAxis = [[UIView alloc] initWithFrame:CGRectMake(self.graphOriginX, self.graphOriginY, AXIS_THICKNESS, -self.graphHeight)];
    yAxis.backgroundColor = [UIColor grayColor];
    
    //Create a view to become the x axis
    UIView *xAxis = [[UIView alloc] initWithFrame:CGRectMake(self.graphOriginX, self.graphOriginY,self.graphWidth ,AXIS_THICKNESS)];
    xAxis.backgroundColor = [UIColor grayColor];
    
    //Add the views to the graph view
    [self.performanceGraphView addSubview:yAxis];
    [self.performanceGraphView addSubview:xAxis];
}


//Draws a single column based on subject information
- (void) drawColumnWithSubject: (Subject*)subject subjectIndex: (int)index {
    //The column is made by a button so it can be interactive
    UIButton* column = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [column setTag:index]; //Give the button a unique tag using the subject index
    [column addTarget:self action:@selector(columnSelectedWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [column setTitle:@"" forState:UIControlStateNormal];
    [column setBackgroundColor:subject.colour]; //Set the column colour to be the subjects colour
    
    //Determine the column height based on the subject's current overall grade
    float columnHeight = (self.graphHeight / 100) * subject.calculateCurrentGrade;
    columnHeight = (columnHeight < 2*AXIS_THICKNESS) ? 2*AXIS_THICKNESS : columnHeight; //Introduce a minimum height
    
    //Add the column to the graph view and animate its height
    CGRect frame = CGRectMake(self.graphOriginX + (self.columnWidth * index), self.graphOriginY, self.columnWidth, 0);
    column.frame = frame;
    [self.performanceGraphView addSubview:column];
    frame.size.height = -columnHeight;
    [UIView animateKeyframesWithDuration:SUBJECT_PERFORMANCE_DURATION delay:(index*COLUMN_ANIMATION_DELAY) options:0 animations:^{column.frame = frame;} completion:nil];
}


//Clicking on a column calls this method
-(void) columnSelectedWithSender: (UIButton*) sender {
    [self showStatsForSubject: [self.subjects objectAtIndex:sender.tag]]; //Uses the button's tag which contains the subject index to detrmine which subject stats should be displayed
}


//Given a subject, show some stats below the graph
-(void) showStatsForSubject: (Subject*) subject{
    //Update storyboard elements with the subject details
    self.selectedSubjectName.text = subject.name;
    [self.selectedSubjectColourBlock setBackgroundColor:subject.colour];
    [self.selectedSubjectColourBlock.layer setCornerRadius:13.0f];
    self.selectedSubjectGrade.text = [NSString stringWithFormat:@"%.0f%%", subject.calculateCurrentGrade];
    
    //Ensure that the fields are being shown
    self.selectedSubjectGrade.hidden = NO;
    self.selectedSubjectColourBlock.hidden = NO;
    self.selectedSubjectName.hidden = NO;
}


@end

