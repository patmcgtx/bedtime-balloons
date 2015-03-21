//
//  KTRoutine.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTRoutine.h"

/*
 * Add methods to the CoreData-generated routine entity class.
 * This class adds custom logic to do calculations, manipluations, etc.
 * on the core data.
 *
 * Note that subclassing KTRoutine does not work since CoreData creates
 * objects or class KTRoutine and not the subclass.  So I use a category,
 * which is extremely helpful and feels a little bit like cheating. ;-)
 */
@interface KTRoutine (plusMethods)

+(KTRoutine*) routineWithName:(NSString*) routineName themeName:(NSString*) themeName tasks:(NSOrderedSet*) routineTasks commit:(BOOL) doCommit;
+(void) moveRoutineAtPosition:(NSUInteger) fromPosition toPosition:(NSUInteger) toPosition commit:(BOOL) doCommit;
+(void) deleteRoutine:(KTRoutine*) routineEntity commit:(BOOL) doCommit;

-(void) insertTasksAtBeginning:(NSMutableOrderedSet*) tasksToAdd commit:(BOOL) doCommit;
-(void) moveTasksAtPosition:(NSUInteger) fromPosition toPosition:(NSUInteger) toPosition commit:(BOOL) doCommit;
-(void) deleteTask:(KTTask*) taskToDelete commit:(BOOL) doCommit;

-(void) updateName:(NSString*) routineName commit:(BOOL) doCommit;

-(BOOL) hasAnyTasks;

-(NSUInteger) totalTimeInMinutes;

-(NSUInteger) totalPossiblePoints;

-(KTTask*) taskBefore:(KTTask*) task;
-(KTTask*) taskAfter:(KTTask*) task;

// Remove related files before deletion
-(void) cleanUp;

@end
