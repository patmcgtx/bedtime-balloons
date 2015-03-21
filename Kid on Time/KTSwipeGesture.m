//
//  KTSwipeGesture.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/20/14.
//
//

#import "KTSwipeGesture.h"
#import "KTRandomGenerator.h"

@interface KTSwipeGesture ()

@end

@implementation KTSwipeGesture

+(KTSwipeGesture*) randomGesture {
    
    KTSwipeGesture* retval = [[KTSwipeGesture alloc] init];
    
    retval.numFingers = [KTRandomGenerator randomIntBetween:1 and:3];
    retval.direction = [KTSwipeGesture randomDirection];
    
    return retval;
}

-(NSString*) localizedInstructions {
    return [NSString stringWithFormat:NSLocalizedString(@"swipe.instructions.format", nil),
            [self localizedFingersString], self.localizedDirectionString];
}

-(NSString*) localizedDirectionString {
    
    NSString* retval = nil;
    
    switch (self.direction) {
            
        case UISwipeGestureRecognizerDirectionDown:
            retval = NSLocalizedString(@"swipe.direction.down", nil);
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
            retval = NSLocalizedString(@"swipe.direction.left", nil);
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            retval = NSLocalizedString(@"swipe.direction.right", nil);
            break;
            
        case UISwipeGestureRecognizerDirectionUp:
            retval = NSLocalizedString(@"swipe.direction.up", nil);
            break;
            
        default:
            break;
    }
    
    return retval;
}


-(NSString*) localizedFingersString {
    
    NSString* numberWordKey = [NSString stringWithFormat:@"number.%lu", (unsigned long)self.numFingers];
    NSString* numberWord = NSLocalizedString(numberWordKey, nil);

    NSString* fingerWord = (self.numFingers == 1 ? NSLocalizedString(@"swipe.finger.singular", nil)
                            : NSLocalizedString(@"swipe.finger.plural", nil));
    
    return [NSString stringWithFormat:@"%@ %@", numberWord, fingerWord];
}

#pragma mark - Internal helpers

+(UISwipeGestureRecognizerDirection) randomDirection {
    
    UISwipeGestureRecognizerDirection retval = UISwipeGestureRecognizerDirectionLeft;
    
    NSInteger randNum = [KTRandomGenerator randomIntBetween:1 and:4];
    switch (randNum) {
            
        case 1:
            retval = UISwipeGestureRecognizerDirectionDown;
            break;
            
        case 2:
            retval = UISwipeGestureRecognizerDirectionLeft;
            break;
            
        case 3:
            retval = UISwipeGestureRecognizerDirectionRight;
            break;
            
        case 4:
            retval = UISwipeGestureRecognizerDirectionUp;
            break;
            
        default:
            break;
    }
    
    return retval;
}

@end
