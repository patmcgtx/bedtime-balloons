//
//  KTBalloon.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KTCocos2dSprite.h"
#import "KTPointCount.h"

typedef enum {
    kKTBalloonStyleNone = 0,
    kKTBalloonStyleRed = 1,
    kKTBalloonStyleBlue = 2,
    kKTBalloonStyleYellow = 3,
} KTBalloonStyle;

@interface KTBalloon : KTCocos2dSprite 

@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) BOOL isPopped;

/*
 Creates a baloon to be stationed at the given position
 */
- (id)initForLayer:(CCLayer*) layer
       withPosition:(CGPoint) posValue
             style:(KTBalloonStyle) style
         forReward:(BOOL) forReward;

/*
 The balloon shows itself, setting it texture to the ballon texture, un-hiding itself, then then,
 ideally, "inflating" itself quickly to full size and "swaying" in the breeze indefinitely. 
 Maybe a slight pause after appearing, too. Resets isPopped to NO.
 */
-(CCTargetedAction*) appearWithDelay:(float) delaySecs;

/*
 When the popping starts, isPopped is set to YES. 
 The balloon's texture changes to the pop/explosion image, 
 and then after a brief delay, it disappears.
 */
-(CCTargetedAction*) pop;

/*
 Creates an action to (maybe) make the balloon's points go to the
 point counter, and make the ballon float away off the top of the
 screen.  Add a delay to make it more spontaneous and life-like.
 
 The "maybe" part has to do with the possibliity that the balloon 
 has been popped.  
 */
-(CCTargetedAction*) maybeCashInTowardsPointCount:(KTPointCount*) pointCount
                                            delay:(float) delaySecs;


/*
 * Helps cyccle through balloon styles (colors)
 */
+(KTBalloonStyle) randomBalloonStyle;

@end
