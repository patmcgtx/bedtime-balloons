//
//  KTRoutine.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTRoutinePlus.h"
#import "KTTaskPlus.h"
#import "KTConstants.h"
#import "RTSTimeUtils.h"
#import "KTDataAccess.h"

@implementation KTRoutine (plusMethods)

+(KTRoutine*) routineWithName:(NSString*) routineName
                    themeName:(NSString*) themeName
                        tasks:(NSOrderedSet*) routineTasks
                       commit:(BOOL) doCommit {
    
    NSManagedObjectContext* ctx = [[KTDataAccess sharedInstance] managedObjectContext];
    
    KTRoutine* retval =  [NSEntityDescription
                          insertNewObjectForEntityForName:@"Routine"
                          inManagedObjectContext:ctx];
    
    retval.name = routineName;
    retval.tasks = routineTasks;
    
    KTTheme* theme = [[[KTDataAccess sharedInstance] themeQueries] themeByName:themeName];
    retval.theme = theme;
    
    // Increment all the other ones to make room for this new one
    NSArray* routines = [[[KTDataAccess sharedInstance] routineQueries] allRoutinesInOrder];
    int i = 1;
    for (KTRoutine* routine in routines) {
        routine.order = [NSNumber numberWithInt:i++];
    }
    
    // Insert the new one at the beginning of the list
    retval.order = [NSNumber numberWithInt:0];
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
    
    return retval;
}

+(void) moveRoutineAtPosition:(NSUInteger) fromPosition toPosition:(NSUInteger) toPosition commit:(BOOL) doCommit {

    // Query all the routines in order
    NSArray* allRoutines = [[[KTDataAccess sharedInstance] routineQueries] allRoutinesInOrder];
    
    // Move the target routine in this tmp set
    NSMutableOrderedSet* routinesAsSet = [NSMutableOrderedSet orderedSetWithArray:allRoutines];
    [routinesAsSet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:fromPosition] toIndex:toPosition];
    
    // Save the new order to the db
    NSUInteger i = 0;
    for (KTRoutine* routine in routinesAsSet) {
        routine.order = [NSNumber numberWithUnsignedLong:i++];
    }
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
}

+(void) deleteRoutine:(KTRoutine*) routineEntity commit:(BOOL) doCommit {
    
    [routineEntity cleanUp];
    
    [[[KTDataAccess sharedInstance] managedObjectContext] deleteObject:routineEntity];
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
}

-(void) insertTasksAtBeginning:(NSMutableOrderedSet*) tasksToAdd commit:(BOOL) doCommit {

    NSMutableOrderedSet* mutableTasks = [self mutableOrderedSetValueForKey:@"tasks"];
    
    for (NSUInteger i = 0; i < [tasksToAdd count]; i++) {
        [mutableTasks insertObject:[tasksToAdd objectAtIndex:i] atIndex:i];
    }
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
}

-(void) moveTasksAtPosition:(NSUInteger) fromPosition toPosition:(NSUInteger) toPosition commit:(BOOL) doCommit {
    
    NSMutableOrderedSet* mutableTasks = [self mutableOrderedSetValueForKey:@"tasks"];
    [mutableTasks moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:fromPosition] toIndex:toPosition];
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
}

-(void) deleteTask:(KTTask*) taskToDelete commit:(BOOL) doCommit {

    [taskToDelete deleteCustomImages];
    
    NSMutableOrderedSet* mutableTasks = [self mutableOrderedSetValueForKey:@"tasks"];
    [mutableTasks removeObject:taskToDelete];
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
}

-(void) updateName:(NSString*) routineName commit:(BOOL) doCommit {
    
    self.name = routineName;
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
}

-(BOOL) hasAnyTasks {
    return [self.tasks count] > 0;
}

/*
 * Adds up the total number of minutes for all tasks
 */
-(NSUInteger) totalTimeInMinutes
{
    NSUInteger retval = 0;
    
    for ( id task in self.tasks )
    {
        if ( [task maxTimeInMinutes] < kKTMaxTaskTimeInMins ) {
            retval += [task maxTimeInMinutes];
        }
    }
    
    return retval;
}

-(NSUInteger) totalPossiblePoints {
    NSUInteger numTasks = [self.tasks count];
    return numTasks * kKTBalloonsPerTask * kKTPointsPerBalloon;
}

-(KTTask*) taskBefore:(KTTask*) task {
    
    KTTask* retval = nil;
    
    NSUInteger taskIndex = [self.tasks indexOfObject:task];
    
    if ( taskIndex != NSNotFound && taskIndex > 0 ) {
        retval = [self.tasks objectAtIndex:(taskIndex - 1)];
    }
    
    return retval;
}

-(KTTask*) taskAfter:(KTTask*) task {
    
    KTTask* retval = nil;
    
    NSUInteger taskIndex = [self.tasks indexOfObject:task];
    NSUInteger totalTasks = [self.tasks count];
    
    if ( taskIndex != NSNotFound && taskIndex < (totalTasks-1) ) {
        retval = [self.tasks objectAtIndex:(taskIndex + 1)];
    }
    
    return retval;
}

-(void) cleanUp {
    
    for (KTTask* task in self.tasks) {
        [task deleteCustomImages];
    }
    
}

@end
