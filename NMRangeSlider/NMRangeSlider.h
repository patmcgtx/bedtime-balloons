//
//  RangeSlider.h
//  RangeSlider
//
//  Created by Murray Hughes on 04/08/2013
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//
// Inspried by: https://github.com/buildmobile/iosrangeslider
/*
 Copyright (C) 2012 Null Monkey Pty. Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#import <UIKit/UIKit.h>

@interface NMRangeSlider : UIControl

// default 0.0
@property(assign, nonatomic) float minimumValue;

// default 1.0
@property(assign, nonatomic) float maximumValue;

// default 0.0. This is the minimum distance between between the upper and lower values
@property(assign, nonatomic) float minimumRange;

// default 0.0 (disabled)
@property(assign, nonatomic) float stepValue;

// If NO the slider will move freely with the tounch. When the touch ends, the value will snap to the nearest step value
// If YES the slider will stay in its current position until it reaches a new step value.
// default NO
@property(assign, nonatomic) BOOL stepValueContinuously;

// defafult YES, indicating whether changes in the sliders value generate continuous update events.
@property(assign, nonatomic) BOOL continuous;

// default 0.0. this value will be pinned to min/max
@property(assign, nonatomic) float lowerValue;

// default 1.0. this value will be pinned to min/max
@property(assign, nonatomic) float upperValue;

// center location for the lower handle control
@property(readonly, nonatomic) CGPoint lowerCenter;

// center location for the upper handle control
@property(readonly, nonatomic) CGPoint upperCenter;


// Images, these should be set before the control is displayed.
// If they are not set, then the default images are used.
// eg viewDidLoad


//Probably should add support for all control states... Anyone?

@property(retain, nonatomic) UIImage* lowerHandleImageNormal;
@property(retain, nonatomic) UIImage* lowerHandleImageHighlighted;

@property(retain, nonatomic) UIImage* upperHandleImageNormal;
@property(retain, nonatomic) UIImage* upperHandleImageHighlighted;

@property(retain, nonatomic) UIImage* trackImage;

@property(retain, nonatomic) UIImage* trackBackgroundImage;

@property(retain, nonatomic) UIImage* valueBackgroundImage;
@property(retain, nonatomic) UILabel* lowerValueLabel;
@property(retain, nonatomic) UILabel* upperValueLabel;
@property(retain, nonatomic) UIView* lowerValueView;
@property(retain, nonatomic) UIView* upperValueView;


//Setting the lower/upper values with an animation :-)
- (void)setLowerValue:(float)lowerValue animated:(BOOL) animated;

- (void)setUpperValue:(float)upperValue animated:(BOOL) animated;

- (void) setLowerValue:(float) lowerValue upperValue:(float) upperValue animated:(BOOL)animated;

@end
