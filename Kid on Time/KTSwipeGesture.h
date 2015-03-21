//
//  KTSwipeGesture.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/20/14.
//
//

#import <Foundation/Foundation.h>

@interface KTSwipeGesture : NSObject

+(KTSwipeGesture*) randomGesture;

@property (nonatomic) NSUInteger numFingers;
@property (nonatomic) UISwipeGestureRecognizerDirection direction;

// e.g. "Swipe two fingers to the right"
-(NSString*) localizedInstructions;

// e.g. "to the right"
-(NSString*) localizedDirectionString;

// e.g. "two fingers"
-(NSString*) localizedFingersString;

@end
