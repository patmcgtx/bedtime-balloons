//
//  KTStepPrototype.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KTStepPrototypeName;

@interface KTStepPrototype : NSManagedObject

@property (nonatomic, retain) NSNumber * canBeDeferred;
@property (nonatomic, retain) NSNumber * canBePaused;
@property (nonatomic, retain) NSNumber * canBeSkipped;
@property (nonatomic, retain) NSNumber * timeInSeconds;
@property (nonatomic, retain) NSSet *names;
@end

@interface KTStepPrototype (CoreDataGeneratedAccessors)

- (void)addNamesObject:(KTStepPrototypeName *)value;
- (void)removeNamesObject:(KTStepPrototypeName *)value;
- (void)addNames:(NSSet *)values;
- (void)removeNames:(NSSet *)values;

@end
