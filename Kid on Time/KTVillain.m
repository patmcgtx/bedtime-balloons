//
//  KTVillain.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTVillain.h"
#import "KTCocos2dUtils.h"
#import "RTSLog.h"

@interface KTVillain ()

@property (nonatomic, strong) CCShaky3D* shakeAction;
@property (nonatomic) CGSize sceneSize;

//
// Timing constants. 
// Tried these as #defines, but that did not work.
// This is probably better, anyways!
//
+(float) cornerBuzzMoveOutTime;  // How long to move into visible corner position
+(float) cornerBuzzPauseTime;    // How long to wait at the corner buzz position
+(float) cornerBuzzMoveBackTime; // How long to move back into hiding from visible corner position
+(float) cornerBuzzTotalTime;    // Total time for the corner buzz routine
+(float) buzzIntervalTime;       // How often to kick off a corner buzz

@end


@implementation KTVillain

@synthesize shakeAction = _shakeAction;
@synthesize sceneSize = _sceneSize;

- (id)initForLayer:(CCLayer*) layer
{
    self = [super initWithFile:@"villain.png" 
                      forLayer:layer 
                        atPos:ccp(-20, 340) // Off-screen position
                        atZPos:100
                          hide:YES];
    
    if (self) {
        
        // Get the scene's dimensions 
        CGRect bounds = layer.boundingBox;
        _sceneSize = bounds.size;
        LOG_COCOS2D(@"Layer dimensions: %f x %f", _sceneSize.width, _sceneSize.height);
        
        // Prep a nice shaky motion for flying all crazy
        _shakeAction = [CCShaky3D  actionWithDuration:5 size:CGSizeMake(2,2) range:2 shakeZ:NO];
    }
    return self;
}

-(void) resetSprite {
            
    [super resetSprite];
    
    // Restart the shaking on the newly recreated sprite
    // TODO Remove this from init since it gets wiped out here anyways?
    [self.sprite runAction: [CCRepeatForever actionWithAction:_shakeAction]];	        
}

#pragma mark - Character primitives

-(CCTargetedAction*) faceRight {
    CCFlipX* flip = [CCFlipX actionWithFlipX:NO];
    return [self actionOnSelf:flip];
}

-(CCTargetedAction*) faceLeft {
    CCFlipX* flip = [CCFlipX actionWithFlipX:YES];
    return [self actionOnSelf:flip];
}

-(CCTargetedAction*) hyperspaceTo:(CGPoint) destination {
    CCPlace* place = [CCPlace actionWithPosition:destination];
    return [self actionOnSelf:place];
}

-(CCTargetedAction*) moveToPosition:(CGPoint) destination
                       withDuration:(float) durationInSeconds
                          easeStart:(BOOL) easeStart
                            easeEnd:(BOOL) easeEnd {
    id show = [CCShow action];
    id move = [CCMoveTo actionWithDuration:durationInSeconds position:destination];
    
    id seq = [CCSequence actions:show, move, nil];
    return [self actionOnSelf:seq];
}

#pragma mark - Complex actions

-(CCTargetedAction*) buzzRandomCorner {
    return [self buzzCorner:randomCornerNotUpperRight()];
}

-(CCTargetedAction*) buzzCorner:(RTSCorner) corner {
    
    CCTargetedAction* faceOut = nil;
    CCTargetedAction* faceBack = nil;
    CGPoint startPos = ccp(0, 0);
    CGPoint pausePos = ccp(0, 0);
    CGPoint endPos = ccp(0, 0);
    
    switch (corner) {
        case kRTSCornerLowerLeft:
            faceOut = [self faceRight];
            faceBack = [self faceLeft];
            startPos = ccp(-30, -30);
            pausePos = ccp(80, 60);
            endPos = ccp(-30, -30);
            break;            
            
        case kRTSCornerUpperLeft:
            faceOut = [self faceRight];
            faceBack = [self faceLeft];
            startPos = ccp(-30, _sceneSize.height + 30);
            pausePos = ccp(60, _sceneSize.height - 50);
            endPos = ccp(-30, _sceneSize.height + 30);
            break;            
            
        case kRTSCornerUpperRight:
            faceOut = [self faceLeft];
            faceBack = [self faceRight];
            startPos = ccp(_sceneSize.width + 30, _sceneSize.height + 30);
            pausePos = ccp(_sceneSize.width -60, _sceneSize.height -50);
            endPos = ccp(_sceneSize.width + 30, _sceneSize.height + 30);
            break;            
            
        case kRTSCornerLowerRight:
            faceOut = [self faceLeft];
            faceBack = [self faceRight];
            startPos = ccp(_sceneSize.width + 30, -30);
            pausePos = ccp(_sceneSize.width - 100, 60);
            endPos = ccp(_sceneSize.width + 30, -30);
            break;            
            
        default:
            LOG_INTERNAL_ERROR(@"Unexpected corner for buzzCorner: %i", corner);
            break;
    }
    
    CCShow* show = [CCShow action];
    CCTargetedAction* positionToStart = [self hyperspaceTo:startPos];
    
    CCMoveTo* moveOut = [CCMoveTo actionWithDuration:[KTVillain cornerBuzzMoveOutTime]
                                         position:pausePos];
    CCEaseOut* easeOut = [CCEaseOut actionWithAction:moveOut rate:2.0];
    
    CCDelayTime* pause = [CCDelayTime actionWithDuration:[KTVillain cornerBuzzPauseTime]];
    
    CCMoveTo* moveBack = [CCMoveTo actionWithDuration:[KTVillain cornerBuzzMoveBackTime]
                                         position:endPos];
    CCEaseIn* easeBack = [CCEaseIn actionWithAction:moveBack rate:2.0];
    
    CCTargetedAction* hide = [self hideOffScreenWithDuration:0.0];
    
    //
    // *Importat*
    // 
    // Be sure to update kKTVillainCornercornerBuzzTotalTime above if you change this routine!
    //
    
    CCSequence* seq = [CCSequence actions:
                       positionToStart, faceOut, show,  // Get in ready position
                       easeOut, pause, // Move to the visible position and wait
                       faceBack, easeBack, // Move back to the starting position
                       hide, // Hyperspace back to the standard hiding position
                       nil];
    return [self actionOnSelf:seq];
}


-(CCTargetedAction*) hideOffScreenWithDuration:(float) durationInSeconds
{
    // Position off the upper-left corner of the screen.
    // (somewhat arbitrary, but maybe a good spot to apprach the baloons)
    CGPoint hidingPos = ccp(-40, _sceneSize.height - 40);
    CCTargetedAction* go = [self hyperspaceTo:hidingPos];
    
    CCHide* hide = [CCHide action];
    
    CCDelayTime* wait = [CCDelayTime actionWithDuration:durationInSeconds];
    
    CCSequence* seq = [CCSequence actions:go, hide, wait, nil];    
    return [self actionOnSelf:seq];
}

-(CCTargetedAction*) moveOffScreenAndHide {
    
    CGPoint offScreenPos;
    offScreenPos.x = -40;
    offScreenPos.y = _sceneSize.height + 40;
    
    // Just happen to ge going off the left side of the screen
    CCTargetedAction* faceLeft = [self faceLeft];
    
    // Move it off the screen!
    CCTargetedAction* move = [self moveToPosition:offScreenPos
                                     withDuration:1.0
                                        easeStart:YES     
                                          easeEnd:NO];
    
    // Once off the screen, hide onesself
    CCTargetedAction* hide = [self hideOffScreenWithDuration:0.0];

    CCSequence* seq = [CCSequence actions:faceLeft, move, hide, nil];    
    return [self actionOnSelf:seq];
}

-(CCTargetedAction*) moveToBalloon:(KTBalloon*) balloon 
                      withDuration:(float) durationInSeconds
{
    CCShow* show = [CCShow action];
    
    // Find the point where the right edge of the villian meets the left edge 
    // of the balloon, and then overlap by a bit.  This is where the balloon pops!
    CGPoint dest;        
    CGFloat overlap = 15;
    dest.x = balloon.position.x - balloon.halfWidth - self.halfWidth + overlap;
    dest.y = balloon.position.y;    
    
    CCTargetedAction* move = [self moveToPosition:dest
                                     withDuration:durationInSeconds
                                        easeStart:NO easeEnd:YES];
    
    CCSequence* seq = [CCSequence actions:show, move, nil];
    return [self actionOnSelf:seq];
}

-(CCTargetedAction*) windUp {
    
    CCTargetedAction* faceRight = [self faceRight];
    CCShow* show = [CCShow action];
    
    ccBezierConfig bez;
    bez.endPosition = ccp(0, 0);
    bez.controlPoint_1 = ccp(-90, -60);
    bez.controlPoint_2 = ccp(-90, 60);
    
    CCBezierBy* loop = [CCBezierBy actionWithDuration:2.0 
                                               bezier:bez];
    
    CCSequence* seq = [CCSequence actions:faceRight, show, loop, nil];
    return [self actionOnSelf:seq];
}

-(CCTargetedAction*) wanderWithDuration:(float) durationInSeconds {
    
    // How long to wait between the end of one buzz and the start of the next
    // How many total buzzes to do
    float pausePerBuzz = [KTVillain buzzIntervalTime] - [KTVillain cornerBuzzTotalTime];
    int numBuzzes = (int) floorf(durationInSeconds / [KTVillain buzzIntervalTime]);
    
    // How much extra time is left over
    float pauseAtEnd =  durationInSeconds - ([KTVillain buzzIntervalTime] * numBuzzes);
    
    // Get together all the actions we need
    NSMutableArray* actions = [NSMutableArray arrayWithCapacity:(numBuzzes*2)+1];
    
    CCDelayTime* wait = [CCDelayTime actionWithDuration:pausePerBuzz];    
    
    for (int i=0; i<numBuzzes; i++) {
        [actions addObject:wait];
        [actions addObject:[self buzzCorner:randomCornerNotUpperRight()]];
    }
    [actions addObject:[CCDelayTime actionWithDuration:pauseAtEnd]];
    
    CCSequence* seq = [CCSequence actionWithArray:actions];
    return [self actionOnSelf:seq];
}

#pragma mark - Timing constants

+(float) cornerBuzzMoveOutTime {
    return 1;
}

+(float) cornerBuzzPauseTime {
    return 2;
}

+(float) cornerBuzzMoveBackTime {
    return 1;
}

+(float) cornerBuzzTotalTime {
    return [KTVillain cornerBuzzMoveOutTime] + 
    [KTVillain cornerBuzzPauseTime] +
    [KTVillain cornerBuzzMoveBackTime];
}

+(float) buzzIntervalTime {
    return 15;    
}

@end
