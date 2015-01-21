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


@end

