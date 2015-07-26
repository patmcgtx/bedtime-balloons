//
//  KTRoutine.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/26/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KTTask, KTTheme;

@interface KTRoutine : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSOrderedSet *tasks;
@property (nonatomic, retain) KTTheme *theme;
@end

@interface KTRoutine (CoreDataGeneratedAccessors)

- (void)insertObject:(KTTask *)value inTasksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTasksAtIndex:(NSUInteger)idx;
- (void)insertTasks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTasksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTasksAtIndex:(NSUInteger)idx withObject:(KTTask *)value;
- (void)replaceTasksAtIndexes:(NSIndexSet *)indexes withTasks:(NSArray *)values;
- (void)addTasksObject:(KTTask *)value;
- (void)removeTasksObject:(KTTask *)value;
- (void)addTasks:(NSOrderedSet *)values;
- (void)removeTasks:(NSOrderedSet *)values;
@end
