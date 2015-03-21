//
//  KTTimer.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface KTTimerOld : NSObject {
    BOOL firstTime;    
}

@property (weak, nonatomic) CCProgressTimer* timerBar;
@property (weak, nonatomic) CCSprite* timerOutline;
@property (weak, nonatomic) CCProgressFromTo* timerCountdownAction;

-(void) addToLayer:(CCLayer*) layer
        atPosition:(CGPoint) pos;

-(void) resetToSeconds:(int) seconds;

@end
