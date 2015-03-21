//
//  KTTimer.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTimerOld.h"
#import "KTCocos2dUtils.h"

@implementation KTTimerOld

@synthesize timerBar;
@synthesize timerOutline;
@synthesize timerCountdownAction;

- (id)init
{
    self = [super init];
    if (self) {
        
        firstTime = YES;
        
        //
        // Setup timer
        //
        timerBar = [CCProgressTimer progressWithSprite:[CCSprite 
                                                     spriteWithFile:@"timer.png"]];
        timerBar.type = kCCProgressTimerTypeBar;
        
        //	Setup for a bar starting from the bottom since the midpoint is 0 for the y
        timerBar.midpoint = ccp(0,0);
        
        //	Setup for a vertical bar since the bar change rate is 0 for x meaning no horizontal change
        timerBar.barChangeRate = ccp(0,1);
        
        // 
        // Setup timer outline
        //
        timerOutline = [CCSprite spriteWithFile:@"timer-outline.png"];
    }
    return self;
}

-(void) resetToSeconds:(int) seconds {
    
    // Stop the current countdown
    [timerBar stopAction:self.timerCountdownAction];
        
    // Action to start the new countdown
    self.timerCountdownAction = [CCProgressFromTo actionWithDuration:seconds from:100 to:2];
    id sequence = nil;
    
    if ( firstTime ) {
        firstTime = NO;
        sequence = [CCSequence actions: self.timerCountdownAction, nil];
    }
    else {
        // Animate the timer to "full" value (not critical, but looks better to do this)
        CCProgressTo* resetAction = [CCProgressTo actionWithDuration:0.5 percent:100];
        sequence = [CCSequence actions: resetAction, self.timerCountdownAction, nil];
    }
    
    // Finally, run them all in sequence.  Otherwise, they will stomp on each other in parallel.
    [timerBar runAction:sequence];
}

-(void) addToLayer:(CCLayer*) layer
        atPosition:(CGPoint) pos  {

    timerBar.position = pos;
    [layer addChild:timerBar z:10];
    
    timerOutline.position = pos;
    [layer addChild:timerOutline z:11];
}


@end
