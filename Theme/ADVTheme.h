//
//  ADVTheme.h
//  MovieBeam
//
//  Created by Tope Abayomi on 07/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADVTheme : NSObject

+ (NSString*)boldFont;
+ (NSString*)mainFont;
+ (UIColor*)mainColor;
+ (UIColor*)foregroundColor;
+ (UIColor*)viewBackgroundColor;


+ (UIImage *)progressTrackImage;
+ (UIImage *)progressProgressImage;
+ (UIImage *)progressPercentTrackImage;
+ (UIImage *)progressPercentProgressImage;
+ (UIImage *)progressPercentProgressValueImage;

+(void)customizeTheme;
+(void)customizeTabBar:(UITabBar*)tabBar;

// Copied slider stuff from Eventer theme
+ (UIImage *)sliderThumbForState:(UIControlState)state;
+ (UIImage *)sliderMinTrack;
+ (UIImage *)sliderMaxTrack;
+ (UIImage *)sliderMinTrackDouble;
+ (UIImage *)sliderMaxTrackDouble;

@end
