//
//  KTTaskTimeDoubleSlider.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/30/14.
//
//

#import "KTTaskTimeDoubleSlider.h"
#import "ADVTheme.h"
#import "KTConstants.h"
#import "RTSLog.h"

@interface KTTaskTimeDoubleSlider ()

@property (nonatomic) NSUInteger previousSelectedMin;
@property (nonatomic) NSUInteger previousSelectedMax;

@end

@implementation KTTaskTimeDoubleSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setup {
    
    self.backgroundColor = [UIColor clearColor];
    self.trackBackgroundImage = [ADVTheme sliderMaxTrackDouble];
    self.trackImage = [ADVTheme sliderMinTrackDouble];
    self.lowerHandleImageNormal = [ADVTheme sliderThumbForState:UIControlStateNormal];
    self.upperHandleImageNormal = [ADVTheme sliderThumbForState:UIControlStateNormal];
    self.lowerHandleImageHighlighted = [ADVTheme sliderThumbForState:UIControlStateNormal];
    self.upperHandleImageHighlighted = [ADVTheme sliderThumbForState:UIControlStateNormal];
    
    // This gives us an exponential slider up to the max number of mins. See -timeRangeChanged below.
    // With log(0) = 1, we really end up with a range of 1-61, and the subtract 1.
    self.minimumValue = 0.0;
    self.maximumValue = log2f(kKTMaxTaskTimeInMins + 1.0);
    
    self.stepValue = 0.0;
    self.minimumRange = 0.001; // Just enough to avoid any overlap between min and max
    
    // Useful when debugging
    //self.continuous = YES;
    
    [self addTarget:self action:@selector(timeRangeChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Properties

-(NSUInteger) selectedMinTimeInMinutes {
    return [self minsFromSliderVal:self.lowerValue];
}

-(NSUInteger) selectedMaxTimeInMinutes {
    return [self minsFromSliderVal:self.upperValue];
}

-(NSUInteger) selectedMinTimeInSeconds {
    return self.selectedMinTimeInMinutes * 60;
}

-(NSUInteger) selectedMaxTimeInSeconds {
    return self.selectedMaxTimeInMinutes * 60;
}

-(void) setSelectedMinTimeInMinutes:(NSUInteger)selectedMinTimeInMinutes {
    [self setLowerValue:[self sliderValFromMins:selectedMinTimeInMinutes] animated:NO];
    self.previousSelectedMin = selectedMinTimeInMinutes;
    [self.delegate taskTimerMinDidChangeTo:selectedMinTimeInMinutes];
}

-(void) setSelectedMaxTimeInMinutes:(NSUInteger)selectedMaxTimeInMinutes {
    [self setUpperValue:[self sliderValFromMins:selectedMaxTimeInMinutes] animated:NO];
    self.previousSelectedMax = selectedMaxTimeInMinutes;
    [self.delegate taskTimerMaxDidChangeTo:selectedMaxTimeInMinutes];
}

#pragma mark - Internal helpers

-(NSUInteger) minsFromSliderVal:(float) sliderVal {
    float exp = exp2f(sliderVal); // Note that exp(0) = 1
    float exp_rounded = floorf(exp * 1000.0) / 1000.0;
    float retval = ceilf(exp_rounded) - 1.0;
    //LOG_TMP_DEBUG(@"+++ slider %f => exp %f => mins %f", sliderVal, exp_rounded, retval);
    return MAX(0.0, retval);
}

-(float) sliderValFromMins:(NSUInteger) mins {
    float retval = log2f((float)mins+1.0);
    //LOG_TMP_DEBUG(@"+++ mins %i => slider %f", mins, retval);
    return MAX(0.0, retval);
}

#pragma mark - Control listeners

-(void) timeRangeChanged:(NMRangeSlider *)slider {

    // lowerValue / upperValue would have changed already.
    // If they overlap, etc. have to fix it retroactively.
    NSUInteger adjustedMin = self.selectedMinTimeInMinutes;
    NSUInteger adjustedMax = self.selectedMaxTimeInMinutes;
    
    if ( adjustedMax <= 0 ) {
        adjustedMax = 1;
    }

    // Deal with overlap
    if ( adjustedMin >= adjustedMax ) {
        // Determine which one changed
        if ( adjustedMin != self.previousSelectedMin ) {
            adjustedMin = adjustedMax - 1;
        }
        else if (adjustedMax != self.previousSelectedMax) {
            adjustedMax = adjustedMin + 1;
        }
    }

    if ( adjustedMin != self.previousSelectedMin) {
        //LOG_TMP_DEBUG(@"slider min => %i", adjustedMin);
        self.selectedMinTimeInMinutes = adjustedMin;
    }

    if ( adjustedMax != self.previousSelectedMax) {
        //LOG_TMP_DEBUG(@"slider max => %i", adjustedMax);
        self.selectedMaxTimeInMinutes = adjustedMax;
    }
}

@end
