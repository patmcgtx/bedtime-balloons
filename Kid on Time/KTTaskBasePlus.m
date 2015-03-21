//
//  KTTaskPrototypePlus.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTaskBasePlus.h"
#import "RTSTimeUtils.h"
#import "KTTaskTypes.h"
#import "KTConstants.h"
#import "KTErrorReporter.h"

@implementation KTTaskBase (plusMethods)

-(NSString*) localizedShortTimeDescription {
    
    NSString* retval = nil;
    BOOL hasMinTime = [self hasTimeMin];
    BOOL hasMaxTime = [self hasTimeLimit];
    NSUInteger minTime = [self minTimeInMinutes];
    NSUInteger maxTime = [self maxTimeInMinutes];
    
    if ( hasMinTime && hasMaxTime ) {
        NSString* minuteWord = (maxTime == 1 ? NSLocalizedString(@"label.minute.short", nil)
                                : NSLocalizedString(@"label.minutes.short", nil));
        retval = [NSString stringWithFormat:@"%lu - %lu %@", (unsigned long)minTime, (unsigned long)maxTime, minuteWord];
    }
    else if ( hasMinTime ) {
        NSString* minuteWord = (minTime == 1 ? NSLocalizedString(@"label.minute.short", nil)
                                : NSLocalizedString(@"label.minutes.short", nil));
        retval = [NSString stringWithFormat:@"%lu+ %@", (unsigned long)minTime, minuteWord];
    }
    else if ( hasMaxTime ) {
        NSString* minuteWord = (maxTime == 1 ? NSLocalizedString(@"label.minute.short", nil)
                                : NSLocalizedString(@"label.minutes.short", nil));
        retval = [NSString stringWithFormat:@"%lu %@", (unsigned long)maxTime, minuteWord];
    }
    
    return retval;
}

-(NSUInteger) maxTimeInMinutes {
    double secondsDouble = [self.timeInSeconds doubleValue];
    double minutes = floor(secondsDouble/60.0);
    return (NSUInteger) minutes;
}

-(NSUInteger) minTimeInMinutes {
    double secondsDouble = [self.minTimeInSeconds doubleValue];
    double minutes = floor(secondsDouble/60.0);
    return (NSUInteger) minutes;
}

-(BOOL) hasTimeLimit {
    float timeLimitSecs = [self.timeInSeconds floatValue];
    return (timeLimitSecs > 0 && timeLimitSecs < kKTMaxTaskTimeInMins*60.0);
}

-(BOOL) hasTimeMin {
    return [self.minTimeInSeconds intValue] > 0;
}

-(BOOL) isCustomTask {
    return [self.type isEqualToString:kKTTaskTypeCustom];
}

/*
 This is the best/cleanest way I could find to get a short alpa-numeric id
 that is unique per task.  There is not a good/easy/clean way to create an
 auto-increment sequence-style int id.  This is pretty good but not great.
 What if the URI format changes?!?!?
 */
-(NSString*) shortId {
    
    NSString* retval = nil;
    
    if ( [self.objectID isTemporaryID] ) {
        [[KTErrorReporter sharedReporter] warnUserWithMessageKey:@"error.db.bad.id"
                                                           error:nil debugInfo:[self.objectID.URIRepresentation absoluteString]];
    }
    else {
        retval = [[[self objectID] URIRepresentation] lastPathComponent];
    }
    
    NSAssert(retval, @"Failed to get task short id");
    return retval;
}


@end
