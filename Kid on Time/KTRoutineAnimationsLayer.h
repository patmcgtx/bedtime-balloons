//
//  KTRoutineAnimationsLayer.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/19/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "CCTouchDelegateProtocol.h"
#import "KTRoutineAnimationsDelegate.h"
#import "KTRoutine.h"
#import "KTTask.h"

/*
 * This class is in charge of running the scene on top of the routine illustrations.
 */
@interface KTRoutineAnimationsLayer : CCLayer <CCTouchOneByOneDelegate>

@property (nonatomic, weak) id<KTRoutineAnimationsDelegate> delegate;

/*
 * Returns the scene to push to the director.
 */
+(CCScene *) scene;

/*
 For performance/responsiveness reasons, we want to prepare all the cocos2d
 action sequences ahead of time, instead of on the fly, ie when a button
 is pushed.  This method prepares all cocosd2d animatio actions for the
 given routine ahead of time.
 
 (This could arguably go into an "init" method, but on a potentially
 expensive method like this, I like to be able to split it out so I
 can control when it is run.
 */
-(void) loadRoutine:(KTRoutine*) routine;

/*
 * Resets balloons, villain, timer bar, etc. for a fresh new task.
 */
-(void) startTask:(KTTask*) task;

/*
 * Sends the villain buzzing a corner, etc. as a visual
 * reminder that he is out there.
 */
-(void) startVillainVisit;

/*
 * How long it takes to run -doVillainVisit
 */
-(NSTimeInterval) durationOfVillainVisits;

/*
 * Starts the process of the villain popping the balloons.
 * The villain drops whatever he was doing and starts popping.
 */
-(void) startPoppingBalloons;

/*
 * Starts the process of collecting balloons for points.
 * The villain drops anythng he was doing and flies offscreen.
 */
-(void) startCollectingBalloons;

/*
 * Displays final score and distributes poppable balloons as a reward.
 */
-(void) startPresentingRewards;

/*
 * The app is going into bg; pause cocos2d, etc.
 */
- (void) goToBackground;

/*
 * The app has returned from bg; restart cocos2d, etc.
 */
- (void) restoreToForegroundWithTime:(NSTimeInterval) newTimeInSeconds
                    timeInBackground:(NSTimeInterval) durationInBg;

/*
 * Hide all controls related to task time limit
 */
-(void) hideTimeLimitControls;

/*
 * Show all controls related to task time limit
 */
-(void) showTimeLimitControls;

-(void) pauseAnimations;
-(void) resumeAnimations;

-(int) numBalloonsEarned;

@end
