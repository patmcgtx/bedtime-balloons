//
//  KTBalloonIcon.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/10/13.
//
//

#import "KTCocos2dSprite.h"

@interface KTBalloonIcon : KTCocos2dSprite

-(id) initForLayer:(CCLayer *)layer
             atPos:(CGPoint)posValue
            atZPos:(int)zPos
              hide:(BOOL)hide;

@end
