//
//  KTRoutineAnimationsDelegate.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/19/13.
//
//

#import <Foundation/Foundation.h>

/*
 * This protocol provides a way to tell the main controller when
 * certain animation events are done, etc.
 */
@protocol KTRoutineAnimationsDelegate <NSObject>

/*
 * Tells the delegate that we are done popping the balloons.
-(void) donePoppingBalloons;
 */

/*
 * Tells the delegate that we are done collecting balloons for points.
 */
-(void) doneCollectingBalloons;

/*
 * Tells the delegate that the final reward scene has been displayed.
-(void) donePresentingRewards;
 */

/*
 * The delegate tells us whether the routine is a custom, user-defined routine
 */
-(BOOL) isCustomRoutine;

/*
 * Gets the exact location of the close/cancel button from the delegate
 */
-(CGPoint) closeButtonCenter;

/*
 * Tells the delegate to kill the routine
 */
// TODO Is this used?
-(void) exitRoutine;

/*
 * Tells the delegate what ration of points were earned vs. possible points
 */
-(void) finishedWithResultRatio:(NSString*) resultRatio;

@end
