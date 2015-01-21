//
//  Qualification.m
//  academicus
//
//  Created by Ben on 29/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Qualification.h"

@implementation Qualification

@dynamic name;
@dynamic institution;
@dynamic displayOrder;
@dynamic years;


//Generate a qualification string
- (NSString*) toStringForPorfolio {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    
    NSMutableArray* yearStrings = [[NSMutableArray alloc]init];
    NSDate *startDate = nil;
    NSDate *endDate = nil;
    
    //For each year generate the year string and calculate information for the qualificaiton string
    for (Year *year in self.years) {

        // Calculate the date ranges of the qualification
        if (!startDate || !endDate) {
            startDate = year.startDate;
            endDate = year.endDate;
        } else {
            if ([startDate timeIntervalSince1970] > [year.startDate timeIntervalSince1970]) { startDate = year.startDate; }
            if ([endDate timeIntervalSince1970] < [year.endDate timeIntervalSince1970]) { endDate = year.endDate; }
        }
        
        [yearStrings insertObject: [year toStringForPorfolio] atIndex:0];
        
    }
    
    //Generate the qualification string
    NSString* qualificationString =[NSString stringWithFormat:@"%@ (%@ - %@)\n%@", self.name, [formatter stringFromDate:startDate], [formatter stringFromDate:endDate], self.institution];
    
    if (yearStrings.count > 0) {
        return [NSString stringWithFormat: @"%@\n%@", qualificationString, [yearStrings componentsJoinedByString:@"\n"]];
    }
    return qualificationString;
}

@end

