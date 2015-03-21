//
//  KTInvisibleSprite.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/13/13.
//
//

#import "KTCocos2dSprite.h"
#import "KTRoutineAnimationsDelegate.h"

// This class provides a way to add an invisible cocos2d node.
// It is being added as sort of a hack fix for KIDSCHED-227 as
// an "invisible" way to pass touch events along to the iOS view.
@interface KTInvisibleCloseButton : KTCocos2dSprite

-(id) initForLayer:(CCLayer *)layer
             atPos:(CGPoint)posValue
            atZPos:(int)zPos
          delegate:(id<KTRoutineAnimationsDelegate>) delegate;

// Signals for the routine to quit if the touch is within this
// node.  Returns YES if quitting, NO otherwise.
-(BOOL) quitRoutineIfTouched:(UITouch*) touch;

@end
