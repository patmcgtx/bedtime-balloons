//
//  RTSTimeUtils.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTSTimeUtils.h"

@implementation RTSTimeUtils

+(NSString*) clockStringFromSeconds:(NSNumber*) secondsNumber 
                         zeroPadded:(BOOL) padded
{
    return [[self class] clockStringFromSecondsInt:[secondsNumber intValue]
                                        zeroPadded:padded];
}

+(NSString*) clockStringFromSecondsInt:(NSInteger) secondsInt
                         zeroPadded:(BOOL) padded
{
    NSInteger minutes = secondsInt / 60;
    NSInteger seconds = secondsInt - minutes * 60;
    
    NSString* format = (padded ? @"%02i:%02i" : @"%2i:%02i");
    return [NSString localizedStringWithFormat:format, minutes, seconds];
}

+(NSString*) localizedStringFromSeconds:(NSNumber*) secondsNumber withLongFormat:(BOOL) useLongFormat
{
    double secondsDouble = [secondsNumber doubleValue];
    double minutes = floor(secondsDouble/60.0);
    double seconds = round(secondsDouble - minutes * 60.0);
    
    NSString* retval = nil;
    
    // KIDSCHED-414
    // TODO Implement real localization -- not sure what "localizedStringWithFormat"
    // even does exactly right now, but it sounds like a start. :-)  I think what
    // I want is to just substitute "min" and "sec" with the local langauges.
    if ( seconds > 0 )
    {
        if ( minutes > 0 ) {
            NSString* timeFormat = useLongFormat ? @"%.0fm %.0fs" : @"%.0f min %.0f sec";
            retval = [NSString localizedStringWithFormat:timeFormat, minutes, seconds];
        }
        else {
            NSString* timeFormat = useLongFormat ? @"%.0f sec" : @"%.0f seconds";
            retval = [NSString localizedStringWithFormat:timeFormat, seconds];
        }
    }
    else 
    {
        NSString* timeFormat = nil;
        
        if ( useLongFormat ) {
            if ( minutes == 1 ) {
                timeFormat = @"%.0f minute";
            }
            else {
                timeFormat = @"%.0f minutes";
            }
        }
        else {
            timeFormat = @"%.0f min";
        }
        
        if ( minutes > 0 ) {
            retval = [NSString localizedStringWithFormat:timeFormat, minutes];
        }
        else {
            retval = @"--";
        }
    }
    
    return retval;    
}

+(KTMinutesSeconds*) secondsToMinutesSeconds:(NSInteger) seconds
{
    KTMinutesSeconds* retval = [KTMinutesSeconds alloc];
    
    retval.minutes = (seconds / 60);
    retval.seconds = (seconds % 60);
    
    return retval;
}


@end
