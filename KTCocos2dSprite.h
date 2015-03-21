//
//  KTCocos2dSprite.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface KTCocos2dSprite : NSObject 

@property (readonly, nonatomic) CCSprite* sprite;
@property (readonly, nonatomic) CGFloat halfWidth;
@property (readonly, nonatomic) NSString* imageName;
@property (readonly, nonatomic) CCLayer* layer;
@property (readonly, nonatomic) CGPoint startingPosition;
@property (readonly, nonatomic) int startingZPosition;
@property (readonly, nonatomic) BOOL startHidden;

- (id)initWithFile:(NSString*) imageFileName 
          forLayer:(CCLayer*) layer
             atPos:(CGPoint) pos
            atZPos:(int) zPos
              hide:(BOOL) hide;

- (id)initWithFile:(NSString*) imageFileName
          forLayer:(CCLayer*) layer
             atPos:(CGPoint)pos
            atZPos:(int) zPos
              hide:(BOOL) hide
              size:(CGRect) rect;

/*
 Creates an action configured to run on this object (self), regardless
 of who calls 'runAction' on it.
 */
- (CCTargetedAction*) actionOnSelf:(CCFiniteTimeAction*) action;

-(CCTargetedAction*) showWithDelay:(float) delaySecs;

-(void) hide;
-(void) show;

/*
 Resets the sprite to its original state (position, image, etc.)
 You actually get a brand new cocos2d sprite out of this.
 This is useful because it sheds any leftover actions, state,
 from the previous sprite.  This helps avoid problems with
 timing, etc. which turn into ugly animation issues.
 */
-(void) resetSprite;

// http://stackoverflow.com/questions/3273945/cocos2d-detect-touch-on-rotated-sprite
- (BOOL) didTouchBeginInNode: (UITouch *) touch;
- (BOOL) worldPointInNode: (CGPoint) worldPoint;

@end
