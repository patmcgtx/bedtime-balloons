//
//  KTTask.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/9/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KTTaskBase.h"

@class KTRoutine;

@interface KTTask : KTTaskBase

@property (nonatomic, retain) KTRoutine *routine;

@end
