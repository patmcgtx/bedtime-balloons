//
//  KTTimer.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTimer.h"
#import "KTCocos2dUtils.h"

@interface KTTimer ()

@property (strong, nonatomic) CCProgressTimer* timerBar;
@property (strong, nonatomic) CCSprite* timerBackground;
@property (strong, nonatomic) CCProgressFromTo* timerCountdownAction;
@property (nonatomic) float totalTimeInSeconds;

@end

@implementation KTTimer

@synthesize timerBar = _timerBar;
@synthesize timerBackground = _timerBackground;
@synthesize timerCountdownAction = _timerCountdownAction;
@synthesize totalTimeInSeconds = _totalTimeInSeconds;

- (id)initForLayer:(CCLayer*) layer
      withPosition:(CGPoint) posValue;
{
    self = [super init];
    if (self) {
        
        _timerCountdownAction = nil;
        _totalTimeInSeconds = 0.0;
        
        //
        // Setup timer
        //
        _timerBar = [CCProgressTimer progressWithSprite:[CCSprite 
                                                        spriteWithFile:@"timer.png"]];
        _timerBar.type = kCCProgressTimerTypeBar;
        
        //	Setup for a bar starting from the bottom since the midpoint is 0 for the y
        _timerBar.midpoint = ccp(0,0);
        
        //	Setup for a vertical bar since the bar change rate is 0 for x meaning no horizontal change
        _timerBar.barChangeRate = ccp(0,1);
        
        // Add it to the layer, behind most other cocos2d sprties such as the villain
        _timerBar.position = ccp(posValue.x - 1, posValue.y);
        [layer addChild:_timerBar z:10];
        
        //
        // And the background
        // 
        _timerBackground = [CCSprite spriteWithFile:@"timer-background.png"];
        _timerBackground.position = posValue;
        [layer addChild:_timerBackground z:9];                
    }
    return self;}


#pragma mark - Actions

-(void) stop {
    
    // Since the countdown actions (timerCountdownAction, etc.)
    // were run on the timerBar, we have to stop them on it as well.
    [self.timerBar stopAllActions];
    
    // In case we're in mid-countdown when the task is stopped, just since that
    // sound in particular is long-running (10 secs) and important.  You hate to
    // finish a task and still have the countdown sound continue like you didn't!
    //[[KTSoundPlayer sharedInstance] stopCountdownSound];
}

-(void) resetToSeconds:(float) totalTimeInSeconds {
    
    self.totalTimeInSeconds = totalTimeInSeconds;
    
    // Stop the current countdown
    [self stop];
    
    // Action to start the new countdown
    self.timerCountdownAction = [CCProgressFromTo actionWithDuration:totalTimeInSeconds from:100 to:1];
    [self.timerBar runAction:self.timerCountdownAction];
}


-(void) resetToSecondsLeft:(float) timeLeftInSeconds {
    
    // Stop the current countdown
    [self stop];
    
    // Restart with the newly adjusted time
    self.timerCountdownAction = [CCProgressFromTo actionWithDuration:timeLeftInSeconds
                                                                from:timeLeftInSeconds * 100 / self.totalTimeInSeconds
                                                                  to:1];
    [self.timerBar runAction:self.timerCountdownAction];
}



-(void) hide {
    self.timerBar.visible = NO;
    self.timerBackground.visible = NO;
}

-(void) show {
    self.timerBar.visible = YES;
    self.timerBackground.visible = YES;
}

@end
