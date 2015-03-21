//
//  KTTaskTimeDoubleSliderDelegate.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/30/14.
//
//

#import <Foundation/Foundation.h>

@protocol KTTaskTimeDoubleSliderDelegate <NSObject>

-(void) taskTimerMinDidChangeTo:(NSUInteger) minTimeInMins;
-(void) taskTimerMaxDidChangeTo:(NSUInteger) maxTimeInMins;

@end
