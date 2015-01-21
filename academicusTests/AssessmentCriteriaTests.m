//
//  AssessmentCriteriaTests.m
//  academicus
//
//  Created by Ben on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AssessmentCriteria.h"

@interface AssessmentCriteriaTests : XCTestCase
@property (nonatomic, retain) NSManagedObjectContext *moc;
@property (strong) AssessmentCriteria *assessment;
@end

@implementation AssessmentCriteriaTests

- (void)setUp {
    [super setUp];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    XCTAssertTrue([store addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = store;
    
    [self createDefaultAssessment];
}


- (void)tearDown {
    [super tearDown];
    self.moc = nil;
}


- (void)createDefaultAssessment {
    self.assessment = [NSEntityDescription insertNewObjectForEntityForName:@"AssessmentCriteria" inManagedObjectContext:self.moc];
    self.assessment.name = @"Test Assessment";
    self.assessment.weighting = [NSNumber numberWithFloat:50];
    self.assessment.deadline = [NSDate date];
    self.assessment.hasGrade = [NSNumber numberWithBool:NO];
    self.assessment.displayOrder = [NSNumber numberWithInt:0];
    self.assessment.subject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:self.moc];;
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
}


- (void)testExample {
    XCTAssert(YES, @"Pass");
}

@end
