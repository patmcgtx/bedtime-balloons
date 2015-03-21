//
//  KTVillain.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KTBalloon.h"
#import "KTCocos2dSprite.h"
#import "RTSCorner.h"


@interface KTVillain : KTCocos2dSprite

/*
 Creates the villain and adds it to the given cocos2d layer
 */
- (id)initForLayer:(CCLayer*) layer;

/*
 Creates actions to turn the villain on way or the other
 */
-(CCTargetedAction*) faceRight;
-(CCTargetedAction*) faceLeft;

/*
 * Creates action to immediately place the villain at the
 * given position, without "moving" him there.
 */
-(CCTargetedAction*) hyperspaceTo:(CGPoint) destination;

/*
 Creates an action to moves to the indicated point.
 */
-(CCTargetedAction*) moveToPosition:(CGPoint) destination
                       withDuration:(float) durationInSeconds
                          easeStart:(BOOL) easeStart
                            easeEnd:(BOOL) easeEnd;

/*
 Creates an action to ~instantly~ transport the villain to its off-screen hiding position
 and wait for the given time.
 */
-(CCTargetedAction*) hideOffScreenWithDuration:(float) durationInSeconds;

/*
 Creates an action to move the villain from its current lcoation to the
 off-screen hiding spot.
 */
-(CCTargetedAction*) moveOffScreenAndHide;

/*
 Creates an action to moves to the indicated balloon. 
 The destination position is slightly offset to the left of the balloon,
 for optimal balloon-popping position.
 */
-(CCTargetedAction*) moveToBalloon:(KTBalloon*) balloon 
                      withDuration:(float) durationInSeconds;

/*
 Creates an action to zoom across a corner. 
 */
-(CCTargetedAction*) buzzRandomCorner;
-(CCTargetedAction*) buzzCorner:(RTSCorner) corner;

/*
 Creates an action to "wind up" before popping a balloon.
 
 This action takes exactly 2 seconds.
 */
-(CCTargetedAction*) windUp;

/*
 Creates an action to wander around the screen for a given time.
 */
-(CCTargetedAction*) wanderWithDuration:(float) durationInSeconds;

@end
