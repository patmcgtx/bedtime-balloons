//
//  KTPoppableBalloon.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/13/13.
//
//

#import "KTBalloon.h"

@interface KTUserPoppableBalloon : KTBalloon

- (id)initForLayer:(CCLayer*) layer
withStartingPosition:(CGPoint) startingPosVal
 withFinalPosition:(CGPoint) finalPosVal
             style:(KTBalloonStyle) style
           bigSize:(BOOL) isBig;

// If the user touch is inside this baloon, then it shold pop itself
-(BOOL) popIfTouched:(UITouch*) touch;

-(CCTargetedAction*) appearAndMoveIntoFinalPositionWithDelay:(ccTime) delay;

@end
