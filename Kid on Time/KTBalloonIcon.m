//
//  KTBalloonIcon.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/10/13.
//
//

#import "KTBalloonIcon.h"

@implementation KTBalloonIcon

-(id) initForLayer:(CCLayer *)layer
             atPos:(CGPoint)posValue
            atZPos:(int)zPos
              hide:(BOOL)hide {
    
    self = [super initWithFile:@"balloon-icon.png"
                      forLayer:layer
                         atPos:posValue
                        atZPos:zPos
                          hide:hide];
	if (self) {
    }
    
    return self;
}



@end
