//
//  OTAppHelper.m
//  OverThere
//
//  Created by Patrick McGonigle on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RTSAppHelper.h"
#import "cocos2d.h"
#import "RTSLog.h"

@interface RTSAppHelper () {
    RTSScreenResolution screenResInternal;
    BOOL checkedRetina;
    BOOL isRetina;
}

@end


@implementation RTSAppHelper

- (id)init
{
    self = [super init];
    if (self) {
        screenResInternal = kRTSScreenResolutionUnknown;
        checkedRetina = NO;
        isRetina = NO;
    }
    return self;
}


-(UIWindow*) appWindow
{
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    return delegate.window;
}


-(CGRect) windowBoundsForLandscape:(BOOL)forLandscape forCocos2d:(BOOL)forCocos2d
{
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    CGRect retval = [[delegate window] bounds];
    
    // Get the screen's bounds and flip it if it's portrait
    if (forLandscape && (retval.size.height > retval.size.width)) {
        retval.size = CGSizeMake( retval.size.height, retval.size.width );
    }
    
    // Scale up or down for cocos2d as neeed
    if (forCocos2d) {
        CCDirector *director = [CCDirector sharedDirector];
        float contentScaleFactor = [director contentScaleFactor];
        
        if( contentScaleFactor != 1 ) {
            retval.size.width *= contentScaleFactor;
            retval.size.height *= contentScaleFactor;
        }
    }
    
    return retval;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(RTSScreenResolution) screenResolution {
    
    // If we haven't figured out the screen size yet, go find it
    if ( screenResInternal == kRTSScreenResolutionUnknown ) {
        
        CGSize size = [[UIScreen mainScreen] bounds].size;
        
        if(size.height == 480)
        {
            screenResInternal = kRTSScreenResolutioniPhone4;
        }
        if(size.height == 568)
        {
            screenResInternal = kRTSScreenResolutioniPhone5;
        }
        else {
            LOG_INTERNAL_ERROR(@"Unknown screen size");
        }
    }

    return screenResInternal;
}

-(BOOL) isRetinaDisplay {
    
    if ( ! checkedRetina ) {
        isRetina = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
                    &&
                    ([UIScreen mainScreen].scale >= 2.0));
        checkedRetina = YES;
    }
    
    return isRetina;
}

#pragma mark Singleton

//
// Singleton implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static RTSAppHelper* _sharedInstance = nil;


+(RTSAppHelper*) sharedInstance
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}


+(id) allocWithZone:(NSZone*) zone
{
    return [self sharedInstance];
}


-(id) copyWithZone:(NSZone*) zone
{
    return self;
}

@end
