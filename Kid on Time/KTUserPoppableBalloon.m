//
//  KTPoppableBalloon.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/13/13.
//
//

#import "KTUserPoppableBalloon.h"
#import "RTSLog.h"
#import "KTConstants.h"

@interface KTUserPoppableBalloon ()

@property (nonatomic) CGPoint finalPos;

@end

@implementation KTUserPoppableBalloon

@synthesize finalPos = _finalPos;

- (id)initForLayer:(CCLayer*) layer
withStartingPosition:(CGPoint) startingPosVal
 withFinalPosition:(CGPoint) finalPosVal
             style:(KTBalloonStyle) style
           bigSize:(BOOL) isBig {

    self = [super initForLayer:layer withPosition:startingPosVal style:style forReward:YES];
    
	if (self) {
        _finalPos.x = finalPosVal.x;
        _finalPos.y = finalPosVal.y;
    }

	return self;
}

-(BOOL) popIfTouched:(UITouch*) touch {
    
    BOOL retval = NO;
    
    if ( [self didTouchBeginInNode:touch] ) {
        
        // If this ballon has already been popped, then don't pop again
        // but do still return YES to indicate that the event is handled
        if ( ! self.isPopped ) {
            CCTargetedAction* popAction = [self pop];            
            [self.sprite runAction:popAction];
        }
        
        retval = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationRewardBalloonPopped
                                                            object:self
                                                          userInfo:nil];
    }

    return retval;
}

-(CCTargetedAction*) appearAndMoveIntoFinalPositionWithDelay:(ccTime) delay {
    
    CCDelayTime* wait = [CCDelayTime actionWithDuration:delay];
    CCShow* appear = [CCShow action];

    CCMoveTo* move = [CCMoveTo actionWithDuration:2.0 position:self.finalPos];
    CCEaseIn* ease = [CCEaseIn actionWithAction:move rate:0.25];
    
    CCSequence* seq = [CCSequence actions:wait, appear, ease, nil];
    return [self actionOnSelf:seq];
}

@end
