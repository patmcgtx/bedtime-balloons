//
//  KTTaskNotifiication.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/13/13.
//
//

#import <Foundation/Foundation.h>
#import "KTTask.h"

@interface KTTaskNotifiication : NSObject

-(id) initWithTask:(KTTask*) task;

-(void) scheduleForDate:(NSDate*) fireDate;

-(void) cancel;

+(void) cancelAll;

@end
