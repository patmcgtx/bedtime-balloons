//
//  KTCreateRoutineDelegate.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/8/14.
//
//

#import <Foundation/Foundation.h>
#import "KTRoutine.h"

@protocol KTCreateRoutineDelegate <NSObject>

-(void) didFinishRoutineCreation:(KTRoutine*) addedRoutine;
-(void) didCancelRoutineCreation;

@end
