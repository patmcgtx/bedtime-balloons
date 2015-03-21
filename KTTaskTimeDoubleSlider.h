//
//  KTTaskTimeDoubleSlider.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/30/14.
//
//

#import "NMRangeSlider.h"
#import "KTTaskTimeDoubleSliderDelegate.h"

@interface KTTaskTimeDoubleSlider : NMRangeSlider

@property (nonatomic, readwrite) NSUInteger selectedMinTimeInMinutes;
@property (nonatomic, readonly) NSUInteger selectedMinTimeInSeconds;

@property (nonatomic, readwrite) NSUInteger selectedMaxTimeInMinutes;
@property (nonatomic, readonly) NSUInteger selectedMaxTimeInSeconds;

@property (nonatomic, weak) id<KTTaskTimeDoubleSliderDelegate> delegate;

-(void) setup;

@end
