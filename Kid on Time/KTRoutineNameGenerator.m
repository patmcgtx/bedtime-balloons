//
//  KTRoutineNameGenerator.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/22/14.
//
//

#import "KTRoutineNameGenerator.h"

@implementation KTRoutineNameGenerator

+(NSString*) generateLocalizedRoutineName {

    // Generate the routine ame from the current day and time
    NSDate* now = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger thisHour = [dateComponents hour];
    
    // Get the day of the week (localized)
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    dateFormatter.locale = [NSLocale currentLocale];
    NSString* localizedDayOfWeek = [dateFormatter stringFromDate:now];
    
    // Determine the part of the day
    NSString* localizedPartOfDay = @"";
    if ( thisHour > 2 && thisHour < 11 ) {
        localizedPartOfDay = NSLocalizedString(@"date.morning.titlecase", nil);
    }
    else if ( thisHour > 17 ) {
        localizedPartOfDay =  NSLocalizedString(@"date.night.titlecase", nil);
    }
    
    // Put it all together
    NSString* retval = [NSString stringWithFormat:@"%@ %@", localizedDayOfWeek, localizedPartOfDay];
    return retval;
}

@end
