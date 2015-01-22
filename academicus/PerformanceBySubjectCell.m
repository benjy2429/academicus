//
//  PerformanceBySubjectCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "PerformanceBySubjectCell.h"

const float AXIS_THICKNESS = 5;
const float SUBJECT_PERFORMANCE_DURATION = 1.0f;
const float COLUMN_ANIMATION_DELAY = 0.3f;

@implementation PerformanceBySubjectCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithSubjects: (NSArray*) subjects {
    self.selectedModuleGrade.hidden = YES;
    self.selectedModuleColourBlock.hidden = YES;
    self.selectedModuleName.hidden = YES;
    [[self.performanceGraphView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    self.subjects = subjects;
    self.graphOriginX = 0.0f;//self.performanceGraphView.frame.origin.x;
    self.graphOriginY = self.performanceGraphView.frame.size.height;
    self.graphWidth = [UIScreen mainScreen].bounds.size.width - 55;
    self.graphHeight = self.performanceGraphView.frame.size.height;
    
    if ([self.subjects count] > 2) {
        self.columnWidth = self.graphWidth / (float)[self.subjects count];
    } else {
        self.columnWidth = self.graphWidth / 2.0f;
    }
    
    int currentIndex = 0;
    for (Subject* subject in self.subjects) {
        [self drawColumnWithSubject:subject subjectIndex:currentIndex];
        currentIndex++;
    }
    
    [self drawAxis];
    
    if ([self.subjects count] > 0) {
        [self showStatsForSubject:[self.subjects objectAtIndex:0]];
    }
}

- (void) drawAxis {
    UIView *yAxis = [[UIView alloc] initWithFrame:CGRectMake(self.graphOriginX, self.graphOriginY, AXIS_THICKNESS, -self.graphHeight)];
    yAxis.backgroundColor = [UIColor grayColor];
    
    UIView *xAxis = [[UIView alloc] initWithFrame:CGRectMake(self.graphOriginX, self.graphOriginY,self.graphWidth ,AXIS_THICKNESS)];
    xAxis.backgroundColor = [UIColor grayColor];
    
    [self.performanceGraphView addSubview:yAxis];
    [self.performanceGraphView addSubview:xAxis];
}


- (void) drawColumnWithSubject: (Subject*)subject subjectIndex: (int)index {
    UIButton* column = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [column setTag:index];
    [column addTarget:self action:@selector(columnSelectedWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [column setTitle:@"" forState:UIControlStateNormal];
    [column setBackgroundColor:subject.colour];
    
    float columnHeight = (self.graphHeight / 100) * subject.calculateCurrentGrade;
    columnHeight = (columnHeight < 2*AXIS_THICKNESS) ? 2*AXIS_THICKNESS : columnHeight;
    
    CGRect frame = CGRectMake(self.graphOriginX + (self.columnWidth * index), self.graphOriginY, self.columnWidth, 0);
    column.frame = frame;
    [self.performanceGraphView addSubview:column];
    frame.size.height = -columnHeight;
    [UIView animateKeyframesWithDuration:SUBJECT_PERFORMANCE_DURATION delay:(index*COLUMN_ANIMATION_DELAY) options:0 animations:^{column.frame = frame;} completion:nil];
}

-(void) columnSelectedWithSender: (UIButton*) sender {
    [self showStatsForSubject: [self.subjects objectAtIndex:sender.tag]];

}


-(void) showStatsForSubject: (Subject*) subject{
    self.selectedModuleName.text = subject.name;
    [self.selectedModuleColourBlock setBackgroundColor:subject.colour];
    [self.selectedModuleColourBlock.layer setCornerRadius:13.0f];
    self.selectedModuleGrade.text = [NSString stringWithFormat:@"%.0f%%", subject.calculateCurrentGrade];
    
    self.selectedModuleGrade.hidden = NO;
    self.selectedModuleColourBlock.hidden = NO;
    self.selectedModuleName.hidden = NO;
}


@end
