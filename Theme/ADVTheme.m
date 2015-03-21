//
//  ADVTheme.m
//  MovieBeam
//
//  Created by Tope Abayomi on 07/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVTheme.h"

@implementation ADVTheme

+ (NSString*)boldFont{
    return @"Avenir-Black";
}

+ (NSString*)mainFont{
    return @"Avenir-Light";
}

+ (UIColor*)mainColor{
    return [UIColor colorWithRed:0.99f green:0.36f blue:0.35f alpha:1.0f];
}

+ (UIColor*)foregroundColor{
    return [UIColor whiteColor];
}

+ (UIColor*)viewBackgroundColor{
    return [UIColor colorWithWhite:0.95f alpha:1.0f];
}

+ (UIImage *)progressTrackImage
{
    UIImage *image = [UIImage imageNamed:@"progress-segmented-track"];
    return image;
}

+ (UIImage *)progressProgressImage
{
    UIImage *image = [UIImage imageNamed:@"progress-segmented-fill"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    return image;
}

+ (UIImage *)progressPercentTrackImage
{
    UIImage *image = [UIImage imageNamed:@"progressTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(14.0, 30.0, 14.0, 30.0)];
    return image;
}

+ (UIImage *)progressPercentProgressImage
{
    UIImage *image = [UIImage imageNamed:@"progressProgress"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)];
    return image;
}

+ (UIImage *)progressPercentProgressValueImage {
    UIImage *image = [UIImage imageNamed:@"progressValue"];
    return image;
}

+(void)customizeTheme{
    
    [UINavigationBar appearance].tintColor = [self mainColor];
    NSMutableDictionary* navbarAttributes = [NSMutableDictionary dictionary];
    navbarAttributes[NSFontAttributeName] = [UIFont fontWithName:[self boldFont] size:19.0f];
    navbarAttributes[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.3f alpha:1.0f];
    [UINavigationBar appearance].titleTextAttributes = navbarAttributes;
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:1.0 green:91.0/255.0 blue:84.0/255.0 alpha:1.0]];
    
    UITabBar* tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setSelectionIndicatorImage:[[UIImage imageNamed:@"tab_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    NSMutableDictionary* segmentAttributes = [NSMutableDictionary dictionary];
    segmentAttributes[NSFontAttributeName] = [UIFont fontWithName:[self mainFont] size:12.0f];
    [[UISegmentedControl appearance] setTitleTextAttributes:segmentAttributes forState:UIControlStateNormal];
    
    UISlider *sliderAppearance = [UISlider appearance];
    
    
    UIImage* sliderMinTrackImage = [[UIImage imageNamed:@"sliderMinTrack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    
    UIImage* sliderMaxTrackImage = [[UIImage imageNamed:@"sliderMinTrack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    
    UIImage* sliderThumbImage = [[UIImage imageNamed:@"sliderThumb"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    
    
    [sliderAppearance setThumbImage:sliderThumbImage forState:UIControlStateNormal];
    [sliderAppearance setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
    [sliderAppearance setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];

    [[UITabBarItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor whiteColor], NSForegroundColorAttributeName,
                             nil]
     forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor whiteColor], NSForegroundColorAttributeName,
                             nil]
     forState:UIControlStateSelected];
    
    //[UILabel appearance].tintColor = [self mainColor];
    //[UILabel appearance].font = [UIFont fontWithName:[self mainFont] size:12.0f];
}

+(void)customizeTabBar:(UITabBar*)tabBar{
    
    int index = 1;
    for (UITabBarItem* tabItem in tabBar.items) {
        NSString* imageName = [NSString stringWithFormat:@"tab%d", index++];
        tabItem.image =[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(5.0, 0.0, -5.0, 0.0);
        tabItem.imageInsets = insets;
    }
}

//
// Copied slider stuff from Eventer theme
//

+ (UIImage *)sliderThumbForState:(UIControlState)state
{
    return [UIImage imageNamed:@"rangeSliderThumb"];
    
    /*
    NSString *name = @"sliderThumb";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    } else if (state == UIControlStateReserved) {
        name = [name stringByAppendingString:@"-small"];
    }
    return [UIImage imageNamed:name];
     */
}

+ (UIImage *)sliderMinTrack
{
    UIImage *image = [UIImage imageNamed:@"rangeSliderMinTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25, 0.0, 25)];
    return image;
}

+ (UIImage *)sliderMaxTrack
{
    UIImage *image = [UIImage imageNamed:@"rangeSliderMaxTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25, 0.0, 25)];
    return image;
}

+ (UIImage *)sliderMinTrackDouble
{
    UIImage *image = [UIImage imageNamed:@"rangeSliderMinTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25, 0.0, 25)];
    return image;
}

+ (UIImage *)sliderMaxTrackDouble
{
    UIImage *image = [UIImage imageNamed:@"rangeSliderMaxTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25, 0.0, 25)];
    return image;
}


@end
