//
//  KTTheme.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/9/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KTRoutine;

@interface KTTheme : NSManagedObject

@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSString * nameKey;
@property (nonatomic, retain) NSSet *routines;
@end

@interface KTTheme (CoreDataGeneratedAccessors)

- (void)addRoutinesObject:(KTRoutine *)value;
- (void)removeRoutinesObject:(KTRoutine *)value;
- (void)addRoutines:(NSSet *)values;
- (void)removeRoutines:(NSSet *)values;

@end
