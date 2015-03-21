//
//  KTCocos2dSprite.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTCocos2dSprite.h"

@implementation KTCocos2dSprite

@synthesize sprite = _sprite;
@synthesize halfWidth = _halfWidth;
@synthesize imageName = _imageName;
@synthesize layer = _layer;
@synthesize startingPosition = _startingPosition;
@synthesize startingZPosition = _startingZPosition;
@synthesize startHidden = _startHidden;

- (id)initWithFile:(NSString*) imageFileName 
          forLayer:(CCLayer*) layer
             atPos:(CGPoint)pos
            atZPos:(int) zPos
              hide:(BOOL) hide {

    self = [super init];

    if (self) {        
        // Save these for later
        _layer = layer;
        _startingPosition = pos;
        _startingZPosition = zPos;
        _startHidden = hide;
        _imageName = imageFileName;
        
        // Set up the cocos2d sprite
        // (I would call [self reset], but I don't think you can do from insidee init.)
        _sprite = [CCSprite spriteWithFile:self.imageName];        
        _sprite.position = pos;
        _halfWidth = _sprite.contentSize.width / 2;        
        _sprite.visible = ! hide;
        
        // Add to the cocos2d layer
        [layer addChild:_sprite z:zPos];
    }
    
    return self;
}

// TODO This is copy & paste from above!  Just one line is different.
// Need a better way but not sure how quickly with Obj-C, but can't
// call a common method on myself during init...
//
// http://qualitycoding.org/objective-c-init/
//
// How else to do it?
//
- (id)initWithFile:(NSString*) imageFileName
          forLayer:(CCLayer*) layer
             atPos:(CGPoint)pos
            atZPos:(int) zPos
              hide:(BOOL) hide
              size:(CGRect) rect {
    
    self = [super init];
    
    if (self) {
        // Save these for later
        _layer = layer;
        _startingPosition = pos;
        _startingZPosition = zPos;
        _startHidden = hide;
        _imageName = imageFileName;
        
        // Set up the cocos2d sprite
        // (I would call [self reset], but I don't think you can do from insidee init.)
        _sprite = [CCSprite spriteWithFile:self.imageName rect:rect];
        _sprite.position = pos;
        _halfWidth = _sprite.contentSize.width / 2;
        _sprite.visible = ! hide;
        
        // Add to the cocos2d layer
        [layer addChild:_sprite z:zPos];
    }
    
    return self;
}

- (CCTargetedAction*) actionOnSelf:(CCFiniteTimeAction*) action {
    return [CCTargetedAction actionWithTarget:self.sprite 
                                       action:action];    
}

-(void) hide {
    self.sprite.visible = NO;
}

-(void) show {
    self.sprite.visible = YES;
}

-(CCTargetedAction*) showWithDelay:(float) delaySecs {
    CCShow* show = [CCShow action];
    CCDelayTime* wait = [CCDelayTime actionWithDuration:delaySecs];
    return [self actionOnSelf:[CCSequence actions:wait, show, nil]];
}

-(void) resetSprite {

    // Set the underlying sprite to a new, pristine state
    // ***without actually wiping it out and getting a new sprite object***.
    // If we wipeit out (like we used to), then all CCTargetedActions
    // previoulsly built on that sprite will now fail to run.
    
    // Stop the sprite in whatever it is doing
    [_sprite stopAllActions];
    
    // Set it back to how it started
    // One of the keys for this to work is that the balloon pop image (balloon-pop.png) 
    // is exactly the same size as the balloon image itself (e.g. balloon-blue.png)
    [_sprite setTexture:[[CCTextureCache sharedTextureCache] addImage:self.imageName]];
    _sprite.position = _startingPosition;
    _sprite.visible = ! _startHidden;
}

#pragma mark - Touch detectors
// http://stackoverflow.com/questions/3273945/cocos2d-detect-touch-on-rotated-sprite

- (BOOL) didTouchBeginInNode: (UITouch *) touch
{
    BOOL retval = NO;
    
    if ( touch.phase == UITouchPhaseBegan ) {        
        CGPoint touchLoc = [touch locationInView: [touch view]];            // convert to "View coordinates" from "window" presumably
        touchLoc = [[CCDirector sharedDirector] convertToGL: touchLoc];     // move to "cocos2d World coordinates"
        
        retval = [self worldPointInNode: touchLoc];
    }
    
    return retval;
}

- (BOOL) worldPointInNode: (CGPoint) worldPoint
{
    // scale the bounding rect of the node to world coordinates so we can see if the worldPoint is in the node.
    CGRect bbox = CGRectMake( 0.0f, 0.0f, self.sprite.contentSize.width, self.sprite.contentSize.height );    // get bounding box in local
    bbox = CGRectApplyAffineTransform(bbox, [self.sprite nodeToWorldTransform] );      // convert box to world coordinates, scaling etc.
    return CGRectContainsPoint( bbox, worldPoint );
}

@end
