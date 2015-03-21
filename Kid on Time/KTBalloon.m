//
//  KTBalloon.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTBalloon.h"
#import "cocos2d.h"
#import "KTConstants.h"
#import "SimpleAudioEngine.h"
#import "KTSoundPlayer.h"
#import "KTBalloonIcon.h"
#import "KTRandomGenerator.h"
#import <stdlib.h>

#define KTBalloonPopImageName @"balloon-pop.png"

@interface KTBalloon ()

@property (nonatomic, strong) CCSprite* poppedSprite;
@property (nonatomic) KTBalloonIcon* rewardIcon;
@property (nonatomic) KTBalloonStyle baloonStyle;
@property (nonatomic) BOOL isForReward;

// Create a read-write "popped" property for internal use
@property (nonatomic) BOOL poppedInternal;

@end


@implementation KTBalloon

@synthesize position = _position;
@synthesize isPopped = _isPopped;
@synthesize poppedSprite = _poppedSprite;
@synthesize rewardIcon = _rewardIcon;
@synthesize baloonStyle = _baloonStyle;
@synthesize poppedInternal = _poppedInternal;

- (id)initForLayer:(CCLayer*) layer
      withPosition:(CGPoint) posValue
             style:(KTBalloonStyle) style
         forReward:(BOOL) forReward {

    _baloonStyle = style;
    _isForReward = forReward;
    
    NSString* baloonStyleString = nil;
    switch (style) {
        case kKTBalloonStyleBlue:
            baloonStyleString = @"blue";
            break;
        case kKTBalloonStyleRed:
            baloonStyleString = @"red";
            break;
        case kKTBalloonStyleYellow:
            baloonStyleString = @"yellow";
            break;            
        default:
            baloonStyleString = @"red";
    }
    
    NSString* imageFileName = nil;
    
    imageFileName = [NSString stringWithFormat:@"balloon-%@.png", baloonStyleString];
    
    self = [super initWithFile:imageFileName
                      forLayer:layer 
                         atPos:posValue
                        atZPos:101
                          hide:YES]; // Balloons start out hidden and "inflate" later
	if (self) {
        
        // Would call [self resetSprite], but can't call a method on myself during init...
        
        _position = posValue;
        _poppedInternal = NO;
        
        //
        // Create a separate sprite to represent the "pop" of the balloon.
        //
        _poppedSprite = [CCSprite spriteWithFile:KTBalloonPopImageName];        
        _poppedSprite.position = self.position;
                
        // It starts out hidden and is shown later, briefly, as needed.
        _poppedSprite.visible = NO;        
        [layer addChild:_poppedSprite z:self.sprite.zOrder];
        
        //
        // Create a reward label to show as needed
        //
        _rewardIcon = [[KTBalloonIcon alloc] initForLayer:layer
                                                    atPos:posValue
                                                   atZPos:100
                                                     hide:YES];
	}
	return self;
}

-(void) resetSprite {

    // TODO Remove this from init since it gets wiped out here anyways?
    
    // Do the basic sprite reset
    [super resetSprite];
    
    // Rest my attrs
    _poppedInternal = NO;
    
    // Remove the old popped sprite
    [_poppedSprite stopAllActions];
    //[_poppedSprite removeFromParentAndCleanup:YES];
    //_poppedSprite = nil;
        
    // Create the new popped sprite
    //_poppedSprite = [CCSprite spriteWithFile:KTBalloonPopImageName];        
    _poppedSprite.position = self.position;
    self.poppedSprite.visible = NO;        
    //[self.layer addChild:_poppedSprite z:self.sprite.zOrder];
    
    // Remove the old reward label
    [_rewardIcon.sprite stopAllActions];
    //[_rewardLabel removeFromParentAndCleanup:YES];
    //_rewardLabel = nil;
    
    // Create the new reward label
    /*
    _rewardLabel = [CCLabelTTF labelWithString:kKTPointsPerBalloonText 
                                      fontName:kKTFontNameRoutineControls 
                                      fontSize:17];
     */
    _rewardIcon.sprite.position = self.position;
    _rewardIcon.sprite.visible = NO;
    
    /*
    switch (self.baloonStyle) {
        // Or use ccc3(..) for the colors...
        case kKTBalloonStyleRed:
            _rewardLabel.color = ccRED;
            break;
        case kKTBalloonStyleBlue:
            _rewardLabel.color = ccBLUE;
            break;
        case kKTBalloonStyleYellow:
            _rewardLabel.color = ccYELLOW;
            break;            
        default:
            _rewardLabel.color = ccBLACK;
            break;
    } 
     */
    //[self.layer addChild:_rewardLabel z:self.sprite.zOrder];    
}

// Give the outside a world a look at my state while keeping
// an internal r/w property for my own use.
-(BOOL) isPopped {
    return self.poppedInternal;
}

#pragma mark - Character actions

-(CCTargetedAction*) appearWithDelay:(float) delaySecs {
    
    // This simulates sort of inflating the balloon    
    CCScaleTo* shrinkToNone = [CCScaleTo actionWithDuration:0 scale:0.0];
    
    CCDelayTime* delay = [CCDelayTime actionWithDuration:delaySecs];
    CCShow* show = [CCShow action];
    CCScaleTo* inflate = [CCScaleTo actionWithDuration:0.25 scale:1.0];
    
    CCSequence* seq = [CCSequence actions:shrinkToNone, delay, show, inflate, nil];
    return [self actionOnSelf:seq];
}

-(CCTargetedAction*) pop {
    
    // Note that I can't set isPopped right now, because we are only
    // creating the action, not running it.  Have to set up a a callback
    // for when the popping is actually done.
    CCCallBlock* updateState = [CCCallBlock actionWithBlock:(^{
        self.poppedInternal = YES;
    })];

    CCAnimation* anim = [CCAnimation animation];
    anim.delayPerUnit = 0.25;
    anim.restoreOriginalFrame = NO;
    anim.loops = 1;
    
    [anim addSpriteFrameWithFilename:@"balloon-pop.png"];

    if ( self.isForReward ) {
        NSUInteger randomRewardNumber = [KTRandomGenerator randomIntBetween:0 and:45]; // We have images 0-45 to pick from
        NSString* randomRewardImageName = [NSString stringWithFormat:@"reward-%02lu.png", (unsigned long)randomRewardNumber];
        [anim addSpriteFrameWithFilename:randomRewardImageName];
    }
    
    CCAnimate* animAction = [CCAnimate actionWithAnimation:anim];    
    
    CCCallBlock* popSoundAction = [CCCallBlock actionWithBlock:(^{
        [[KTSoundPlayer sharedInstance] playPopSound];
    })];
    
    CCHide* hideIt = [CCHide action];
    CCSequence* seq = nil;
    
    if ( self.isForReward ) {
        CCMoveBy* dropReward = [CCMoveBy actionWithDuration:1.0 position:ccp(0, -300)];
        CCEaseExponentialIn* easeDrop = [CCEaseExponentialIn actionWithAction:dropReward];
        seq = [CCSequence actions:updateState, popSoundAction,
               animAction, easeDrop, hideIt, nil];
    }
    else {
        seq = [CCSequence actions:updateState, popSoundAction,
               animAction, hideIt, nil];
    }

    return [self actionOnSelf:seq];
}

-(CCTargetedAction*) maybeCashInTowardsPointCount:(KTPointCount*) pointCount
                                       delay:(float) delaySecs {
    
    CCTargetedAction* retval = nil;
    
    // Only do this if the balloon is not popped!
    if ( self.isPopped ) {
        // Do nothing
        retval = [CCDelayTime actionWithDuration:0.0];
    }
    else {        
        // Initial delay
        CCDelayTime* wait = [CCDelayTime actionWithDuration:delaySecs];
        
        // Define the balloon fly-away sequence
        // Move up and slightly to the right, to simulate wind.
        // This should be high enough to clear the top of the screen.
        CCMoveBy* balloonAway = [CCMoveBy actionWithDuration:1.0 position:ccp(10, 60)];
        CCHide* hide = [CCHide action];
        CCSequence* balloonSeq = [CCSequence actions:balloonAway, hide, nil];
        CCTargetedAction* balloonSeqTargeted = [CCTargetedAction actionWithTarget:self.sprite
                                                                           action:balloonSeq];
        
        //
        // Define the reward label sequence
        //
        
        // First fade in the reward points label where the balloon was
        CCShow* showReward = [CCShow action];
        CCFadeIn* rewardIn = [CCFadeIn actionWithDuration:0.5];
        
        // Then animate the reward points going to the point counter
        ccBezierConfig bezConfig;
        bezConfig.controlPoint_1  = ccp(-10, -40);
        bezConfig.controlPoint_2  = ccp(5, -60);
        bezConfig.endPosition = ccp(20, -40);
        CCBezierBy* rewardBez = [CCBezierBy actionWithDuration:0.5 bezier:bezConfig];
        
        // The +30 position below is kind of a hack.  It depends on the balloon icon
        // being 30 points to the right of the point count label.  That should work out,
        // but ideally I would just use the position of the balloon icon itself.  Also,
        // there is not a good way to do that since the the balloon icon is in the
        // storyboard and the label is in cocos2d, different coordinate systems...
        CCMoveTo* rewardMove = [CCMoveTo actionWithDuration:0.65
                                                   position:ccp(pointCount.position.x+40, pointCount.position.y)];
        
        // Then make the reward points disappear "into" the counter
        CCHide* hideReward = [CCHide action];

        CCCallBlock* balloonCollectSoundAction = [CCCallBlock actionWithBlock:(^{
            [[KTSoundPlayer sharedInstance] playBalloonCollectSound];
        })];

        // And update the counter's total
        CCTargetedAction* addPoints = [pointCount addPointsForOneBalloon];
        
        CCSequence* rewardSeq = [CCSequence actions:showReward, rewardIn, 
                                 rewardBez, rewardMove, addPoints, balloonCollectSoundAction,
                                 hideReward, nil];
        CCTargetedAction* rewardTargeted = [CCTargetedAction
                                            actionWithTarget:_rewardIcon.sprite
                                            action:rewardSeq];
        
        //
        // Define the balloon floating away and the reward showin 
        // up simultaneously
        //
        CCSpawn* simultaneous = [CCSpawn actions:balloonSeqTargeted, rewardTargeted, nil];
        
        //
        // Tie it all together
        //
        CCSequence* seq = [CCSequence actions:wait, simultaneous, nil];
        return [self actionOnSelf:seq];
    }
    
    return retval;
}


#pragma mark - Class functions

+(KTBalloonStyle) randomBalloonStyle {

    // Random 0 to 2.  This is technically not a great rand,
    // but doesn't matter much for this purpse.
    int r = rand() % 3;
    
    switch (r) {
        case 0:
            return kKTBalloonStyleRed;
        case 1:
            return kKTBalloonStyleYellow;
        case 2:
            return kKTBalloonStyleBlue;
        default:
            return kKTBalloonStyleRed;
    }
}

@end
