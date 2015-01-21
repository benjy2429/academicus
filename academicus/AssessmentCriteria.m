//
//  AssessmentCriteria.m
//  academicus
//
//  Created by Ben on 29/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "AssessmentCriteria.h"

@implementation AssessmentCriteria

@dynamic deadline;
@dynamic finalGrade;
@dynamic name;
@dynamic negativeFeedback;
@dynamic notes;
@dynamic positiveFeedback;
@dynamic rating;
@dynamic reminder;
@dynamic weighting;
@dynamic hasGrade;
@dynamic subject;
@dynamic displayOrder;


#pragma mark - Local Notifications

// Create a reminder that the user can set
- (void)createReminder {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = self.reminder;
    notification.alertBody = [NSString stringWithFormat:@"%@ is due soon!", self.name];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.userInfo = @{@"reminder": self.reminder};
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


// Delete a reminder that the user has set
- (void)removeReminder {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSDictionary *userInfo = notification.userInfo;
        
        if ([userInfo valueForKey:@"reminder"] == self.reminder) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}


// If enabled, automatically create a reminder 3 weeks after the deadline to notify the user to add a grade
- (void)createDeadlineReminderByReplacing:(BOOL)willReplace {
    // Calculate the date 3 weeks after the deadline to set a notification reminder
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:21];
    NSDate *deadlineReminderDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.deadline options:0];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"notificationsEnabled"] && [deadlineReminderDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
        
        if (willReplace) { [self removeDeadlineReminder]; }
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = deadlineReminderDate;
        notification.alertBody = [NSString stringWithFormat:@"Don't forget to add a grade for %@!", self.name];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.userInfo = @{@"isDeadlineReminder" : @YES, @"deadline": self.deadline};
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


// If enabled, remove an automatic add grade reminder which was set 3 weeks after the deadline
- (void)removeDeadlineReminder {
    // Find the existing noification and delete it
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSDictionary *userInfo = notification.userInfo;
        
        if ([[userInfo valueForKey:@"isDeadlineReminder"] boolValue] && [userInfo valueForKey:@"deadline"] == self.deadline) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}


//Return a human friendly version of the number of days remaining until the deadline
- (NSString*) getFriendlyDaysRemaining {
    //Get todays date
    NSDate *currentDate = [NSDate date];
    
    //Calculate the difference in days
    NSDate *deadlineDate = self.deadline;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&currentDate interval:nil forDate:currentDate];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&deadlineDate interval:nil forDate:deadlineDate];
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:currentDate toDate:deadlineDate options:0];
    
    //Add a few special cases depending on the difference between today and the deadline
    switch ([difference day]) {
        case 0: return @"Due today"; break; //If due today
        case 1: return @"Due tomorrow"; break; //If due tomorrow
        default: {
            //If the number of day exceeds a year, display the date instead
            if ([difference day] < 366) {
                return [NSString stringWithFormat: @"You have %i days remaining", (int)[difference day]];
            } else {
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                return [NSString stringWithFormat: @"Due on %@", [dateFormatter stringFromDate:self.deadline]];
            }
            break;
        }
    }
}


//Return a formatted string containing deatils for the portfolio page
- (NSString*) toStringForPorfolio {
    float weightedGrade = (([self.finalGrade floatValue] * [self.weighting floatValue]) / 100);
    return [NSString stringWithFormat:@"                  %@: %.0f%%", self.name, weightedGrade];
}


@end

