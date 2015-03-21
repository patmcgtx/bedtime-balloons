//
//  KTInvisibleSprite.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/13/13.
//
//

#import "KTInvisibleCloseButton.h"

@interface KTInvisibleCloseButton ()

@property (nonatomic, weak) id<KTRoutineAnimationsDelegate> layerDelegate;

@end

@implementation KTInvisibleCloseButton

@synthesize layerDelegate = _layerDelegate;

-(id) initForLayer:(CCLayer *)layer
             atPos:(CGPoint)posValue
            atZPos:(int)zPos
          delegate:(id<KTRoutineAnimationsDelegate>) delegate {
    
    // Have to do this to prevent the invisible close button from getting
    // too big and causing accidental closing (KIDSCHED-283).
    // Kind of klugy, but...
    CGRect myRect = CGRectMake(0.0, 0.0, 44.0, 44.0);
    
    self = [super initWithFile:@"close.png"
                      forLayer:layer
                         atPos:posValue
                        atZPos:zPos
                          hide:YES
                          size:myRect];
            
	if (self) {
        _layerDelegate = delegate;
    }
    
    return self;
}

-(BOOL) quitRoutineIfTouched:(UITouch*) touch {
    
    if ( [self didTouchBeginInNode:touch] ) {
        [self.layerDelegate exitRoutine];
        return YES;
    }
    
    return NO;
}

@end
