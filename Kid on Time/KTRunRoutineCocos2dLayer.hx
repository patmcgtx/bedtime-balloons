//
//  KTRunRoutineCocos2dLayer.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KTRunRoutineCocos2dLayerDelegate.h"
#import "CCTouchDelegateProtocol.h"

#import "KTRoutine.h"

/*
 This class is in charge of running the scene on top of the task illustration.
 Namely, it shows the villain wandering around and popping balloons.
 */
@interface KTRunRoutineCocos2dLayer : CCLayer <CCTargetedTouchDelegate>

// I think strong might cause create a deadlock situation, so go weak (I guess!)
@property (nonatomic, weak) id<KTRunRoutineCocos2dLayerDelegate> delegate;

/* 
 For performance/responsiveness reasons, we want to prepare all the cocos2d
 action sequences ahead of time, instead of on the fly, ie when a button
 is pushed.  This method prepares all cocosd2d animatio actions for the
 given routine ahead of time.
 
 (This could arguably go into an "init" method, but on a potentially
 expensive method like this, I like to be able to split it out so I 
 can control when it is run.
 */
-(void) prepareForRoutine:(KTRoutine*) routine;


/*
 * Returns the scene to push to the director.
 */
+(CCScene *) scene;

/*
 Starts off a task (timer, villain popping balloons, etc.)
 The task runs asynchronously and indefinitely.  
 Call wrapUpTask when you want to kill the task.
 */
-(void) startTaskNumber:(int) taskNum 
               WithTime:(int) taskTimeInSeconds;

/*
 Tells this object that the currently running task is done, and we should
 now perform a "wrap up" routine, e.g. make the villain go away, show
 reward points for each remaining balloon, etc.
 
 This wrap-up routine is *started* immediately but runs asynchronously.
 This object lets its delegate know when the wrap up is actually *done*
 by calling its KTRunRoutineCocos2dLayerDelegate readyForNextTask method.
 */
-(void) wrapUpTaskNumber:(int) taskNum isLastTask:(BOOL) isLast;

/*
 * Displays final score and distributes poppable balloobs as a reward
 */
-(void) showRoutineFinalRewardScreen;

/*
 * The app is going into bg; pause cocos2d, etc.
 */
- (void) goToBackground;

/*
 * The app has returned from bg; restart cocos2d, etc.
 */
- (void) restoreToForegroundWithTime:(NSTimeInterval) newTimeInSeconds
                    timeInBackground:(NSTimeInterval) durationInBg;

@end
