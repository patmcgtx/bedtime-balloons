//
//  KTTask.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/26/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KTTaskBase.h"

@class KTRoutine;

@interface KTTask : KTTaskBase

@property (nonatomic, retain) NSNumber * imageStateRaw;
@property (nonatomic, retain) KTRoutine *routine;

@end
