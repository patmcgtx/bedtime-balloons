//
//  KTStep.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KTRoutine;

@interface KTStep : NSManagedObject

@property (nonatomic, retain) NSNumber * canBeDeferred;
@property (nonatomic, retain) NSNumber * canBePaused;
@property (nonatomic, retain) NSNumber * canBeSkipped;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * timeInSeconds;
@property (nonatomic, retain) KTRoutine *routine;

@end
