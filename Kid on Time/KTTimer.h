//
//  KTTimer.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*
 Represents the vertical, hourglass-style timer.
 
 Note that unlike the other animated objects such as KTVillain, KTBalloon,
 etc. all actions on this class actually take effect immediately.  On the
 other mentioned cocos2d classes, actions are built up and executed later.
 */
@interface KTTimer : NSObject

/*
 Creates a timer to be stationed at the given position
 */
- (id)initForLayer:(CCLayer*) layer
      withPosition:(CGPoint) posValue;

/*
 * Sets the timer to a new time to countdown from.
 * Restarts countdown from that time.  So maybe we
 * rest the time ot 1 minute and star counting down
 * from 60 seconds.
 */
-(void) resetToSeconds:(float) totalTimeInSeconds;

/*
 * Keeps current total countdown time but changes the
 * current time left in the countdow.  So maybe we have
 * a current timer of 1 minute, but we need to set the
 * time left to 35 seconds after coming back from the
 * background.
 **/
-(void) resetToSecondsLeft:(float) timeLeftInSeconds;

-(void) stop;

-(void) hide;
-(void) show;

@end
