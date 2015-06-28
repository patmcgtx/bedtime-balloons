//
//  KTEditRoutineDelegate.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/21/14.
//
//

#import <Foundation/Foundation.h>

@protocol KTEditRoutineDelegate <NSObject>

-(void) didInsertTasksAtBeginningOfRoutine:(NSMutableOrderedSet*) insertedTasks;
-(void) didFinishEditingRoutine;

@end
