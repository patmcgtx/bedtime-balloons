//
//  RTSTimeUtils.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTMinutesSeconds.h"

@interface RTSTimeUtils : NSObject

/*
 * Converts a time interval (in seconds) to clock-style string, 
 * for example from 120 seconds to "02:00".  This is most useful
 * for presenting a running clock or timer.
 */
 +(NSString*) clockStringFromSeconds:(NSNumber*) secondsNumber 
                          zeroPadded:(BOOL) padded;

/*
 * Optimized for pure int
 */
+(NSString*) clockStringFromSecondsInt:(NSInteger) secondsInt
                            zeroPadded:(BOOL) padded;

/*
 * Converts a time interval (in seconds) a user-friendly time string,
 * for example from 120 seconds to "2 min" or "1m 30s".
 */
+(NSString*) localizedStringFromSeconds:(NSNumber*) secondsNumber withLongFormat:(BOOL) useLongFormat;


/*
 * Converts a raw number of seconds into minutes + seconds
 */
+(KTMinutesSeconds*) secondsToMinutesSeconds:(NSInteger) seconds;

@end
