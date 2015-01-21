//
//  academicusTests.m
//  academicusTests
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Qualification.h"
#import "Year.h"
#import "Subject.h"
#import "AssessmentCriteria.h"

@interface academicusTests : XCTestCase
@property (nonatomic, retain) NSManagedObjectContext *moc;
@property (nonatomic, strong) Qualification *qualification;
@property (nonatomic, strong) Year *year;
@property (nonatomic, strong) Subject *subject;
@property (nonatomic, strong) AssessmentCriteria *assessment;
@end

@implementation academicusTests

- (void)setUp {
    [super setUp];
    [self createManagedObjectContext];
    self.qualification = [self createQualification:@{}];
    self.year = [self createYear:@{}];
    self.subject = [self createSubject:@{}];
    self.assessment = [self createAssessment:@{}];
}


- (void)tearDown {
    [super tearDown];
    self.moc = nil;
    self.qualification = nil;
    self.year = nil;
    self.subject = nil;
    self.assessment = nil;
}


- (void)createManagedObjectContext {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    XCTAssertTrue([store addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = store;
}


- (Qualification *)createQualification:(NSDictionary *)dict {
    Qualification *qualification = [NSEntityDescription insertNewObjectForEntityForName:@"Qualification" inManagedObjectContext:self.moc];
    qualification.name = [dict objectForKey:@"name"] ? [dict objectForKey:@"name"] : @"Test Qualification";
    qualification.institution = [dict objectForKey:@"institution"] ? [dict objectForKey:@"institution"] : @"School Name";
    qualification.displayOrder = [dict objectForKey:@"displayOrder"] ? [dict objectForKey:@"displayOrder"] : [NSNumber numberWithInt:0];
    qualification.years = [[NSOrderedSet alloc] init];
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
    return qualification;
}


- (Year *)createYear:(NSDictionary *)dict {
    Year *year = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:self.moc];
    year.name = [dict objectForKey:@"name"] ? [dict objectForKey:@"name"] : @"Test Year";
    year.startDate = [dict objectForKey:@"startDate"] ? [dict objectForKey:@"startDate"] : [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    year.endDate = [dict objectForKey:@"endDate"] ? [dict objectForKey:@"endDate"] : [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
    year.qualification = [dict objectForKey:@"qualification"] ? [dict objectForKey:@"qualifiction"] : self.qualification;
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
    return year;
}


- (Subject *)createSubject:(NSDictionary *)dict {
    Subject *subject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:self.moc];
    subject.name = [dict objectForKey:@"name"] ? [dict objectForKey:@"name"] : @"Test Subject";
    subject.yearWeighting = [dict objectForKey:@"yearWeighting"] ? [dict objectForKey:@"yearWeighting"] : [NSNumber numberWithFloat:100.0f];
    subject.targetGrade = [dict objectForKey:@"targetGrade"] ? [dict objectForKey:@"targetGrade"] : [NSNumber numberWithInt:70];
    subject.colour = [dict objectForKey:@"colour"] ? [dict objectForKey:@"colour"] : [UIColor redColor];
    subject.teacherName = [dict objectForKey:@"teacherName"] ? [dict objectForKey:@"teacherName"] : @"Mr. Teacher";
    subject.teacherEmail = [dict objectForKey:@"teacherEmail"] ? [dict objectForKey:@"teacherEmail"] : @"teacher@schoolmail.com";
    subject.displayOrder = [dict objectForKey:@"displayOrder"] ? [dict objectForKey:@"displayOrder"] : [NSNumber numberWithInt:0];
    subject.year = [dict objectForKey:@"year"] ? [dict objectForKey:@"year"] : self.year;
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
    return subject;
}


- (AssessmentCriteria *)createAssessment:(NSDictionary *)dict {
    AssessmentCriteria *assessment = [NSEntityDescription insertNewObjectForEntityForName:@"AssessmentCriteria" inManagedObjectContext:self.moc];
    assessment.name = [dict objectForKey:@"name"] ? [dict objectForKey:@"name"] : @"Test Assessment";
    assessment.weighting = [dict objectForKey:@"weighting"] ? [dict objectForKey:@"weighting"] : [NSNumber numberWithFloat:100.0f];
    assessment.deadline = [dict objectForKey:@"deadline"] ? [dict objectForKey:@"deadline"] : [NSDate date];
    assessment.reminder = [dict objectForKey:@"reminder"] ? [dict objectForKey:@"reminder"] : nil;
    assessment.displayOrder = [dict objectForKey:@"displayOrder"] ? [dict objectForKey:@"displayOrder"] : [NSNumber numberWithInt:0];
    assessment.subject = [dict objectForKey:@"subject"] ? [dict objectForKey:@"subject"] : self.subject;
    assessment.hasGrade = [dict objectForKey:@"hasGrade"] ? [dict objectForKey:@"hasGrade"] : [NSNumber numberWithBool:NO];
    assessment.rating = [dict objectForKey:@"rating"] ? [dict objectForKey:@"rating"] : nil;
    assessment.positiveFeedback = [dict objectForKey:@"positiveFeedback"] ? [dict objectForKey:@"positiveFeedback"] : nil;
    assessment.negativeFeedback = [dict objectForKey:@"negativeFeedback"] ? [dict objectForKey:@"negativeFeedback"] : nil;
    assessment.notes = [dict objectForKey:@"notes"] ? [dict objectForKey:@"notes"] : nil;
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
    return assessment;
}


- (void)testAssessmentCreateReminder {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *reminderDate = [cal dateByAddingUnit:NSCalendarUnitDay value:21 toDate:self.assessment.deadline options:0];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    AssessmentCriteria *assessment = [self createAssessment:@{@"reminder":reminderDate}];
    NSArray *currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    XCTAssertTrue(currentNotifications.count == 0);
    [assessment createReminder];
    currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    XCTAssertTrue(currentNotifications.count == 1);
    UILocalNotification *notification = [currentNotifications objectAtIndex:0];
    NSDictionary *userInfo = notification.userInfo;
    XCTAssertTrue([[userInfo objectForKey:@"reminder"] isEqualToDate:assessment.reminder]);
}


- (void)testAssessmentRemoveReminder {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *reminderDate = [cal dateByAddingUnit:NSCalendarUnitDay value:21 toDate:self.assessment.deadline options:0];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    AssessmentCriteria *assessment = [self createAssessment:@{@"reminder":reminderDate}];
    [assessment createReminder];
    NSArray *currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    XCTAssertTrue(currentNotifications.count == 1);
    [assessment removeReminder];
    currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    XCTAssertTrue(currentNotifications.count == 0);
}


- (void)testAssessmentCreateDeadlineReminder {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    XCTAssertTrue(currentNotifications.count == 0);
    [self.assessment createDeadlineReminder];
    currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    XCTAssertTrue(currentNotifications.count == 1);
    UILocalNotification *notification = [currentNotifications objectAtIndex:0];
    NSDictionary *userInfo = notification.userInfo;
    XCTAssertTrue([userInfo objectForKey:@"isDeadlineReminder"]);
    XCTAssertTrue([[userInfo objectForKey:@"deadline"] isEqualToDate:self.assessment.deadline]);
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *fireDate = [cal dateByAddingUnit:NSCalendarUnitDay value:21 toDate:self.assessment.deadline options:0];
    XCTAssertTrue([notification.fireDate isEqualToDate:fireDate]);
}


- (void)testAssessmentRemoveDeadlineReminder {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.assessment createDeadlineReminder];
    NSArray *currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    XCTAssertTrue(currentNotifications.count == 1);
    [self.assessment removeDeadlineReminder];
    currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    XCTAssertTrue(currentNotifications.count == 0);
}


@end

