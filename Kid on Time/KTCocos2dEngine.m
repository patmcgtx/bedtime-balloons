//
//  OTLandmarkHUDCocosMgr.m
//  OverThere
//
//  Created by Patrick McGonigle on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KTCocos2dEngine.h"
#import "RTSLog.h"
#import "RTSAppHelper.h"

@implementation KTCocos2dEngine


#pragma mark Object lifecycle

- (id)init
{
    LOG_OBJ_LIFECYCLE(@"init");
    
    self = [super init];
    
    if (self) {
        
        // Set up the global the cocos2d director.
        // This is mostly taken from the standard cocos2d template 
        // app delegate and grafted on here.  Also made some changes
        // to support a transparent background.
        
        CCDirectorIOS* director = (CCDirectorIOS*) [CCDirector sharedDirector];        

        [director setDelegate:self];
        [director setProjection:kCCDirectorProjection2D];

        //glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        glClearColor(0.0, 0.0, 0.0, 0.0);
        //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        /*
        if( ! [director enableRetinaDisplay:YES] ) {
            LOG_COCOS2D(@"Retina Display Not supported");
        }
         */
                
        [director setDisplayStats:NO];        
        [director setAnimationInterval:1.0/60];
        
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];    
    }
    
    return self;
}


/*
-(void) dealloc
{
    LOG_OBJ_LIFECYCLE(@"dealloc");
    
    // Being a singleton, this should never get called, but...
    _glView = nil;

    [[CCDirector sharedDirector] end];
}
*/

#pragma mark Pausable

-(void) pause 
{
    LOG_APP_LIFECYCLE(@"pause");

    if ( ! [[CCDirector sharedDirector] isPaused] ) {
        [[CCDirector sharedDirector] pause];
    }
}


-(void) resume
{
    LOG_APP_LIFECYCLE(@"resume");
    
    if ( [[CCDirector sharedDirector] isPaused] ) {
        [[CCDirector sharedDirector] resume];
    }
}


#pragma mark Main

-(void) stop
{
    LOG_APP_LIFECYCLE(@"stop");
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] end];
    [self purge];

    // TODO Do these?
	//CCDirector *director = [CCDirector sharedDirector];	
	//[[director openGLView] removeFromSuperview];
}

-(void) purge
{
    LOG_APP_LIFECYCLE(@"purge");
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) significantTimeChange
{
    LOG_APP_LIFECYCLE(@"significantTimeChange");
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (CCGLView*) view
{    
    // Create the GL view if needed
    if ( ! _glView ) {
        
        LOG_OBJ_LIFECYCLE(@"creating CCGLView");
        
        CCDirector *director = [CCDirector sharedDirector];
        
        //
        // Create the CCGLView manually
        //  1. Create a RGB565 format. Alternative: RGBA8
        //	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
        /*
        _glView = [[CCGLView 
                            viewWithFrame:[OTAppHelper windowBoundsForLandscape:NO forCocos2d:YES]
                            pixelFormat:kEAGLColorFormatRGBA8
                            depthFormat:0] retain];
         */
        CGRect size = [[RTSAppHelper sharedInstance]
                       windowBoundsForLandscape:YES 
                       forCocos2d:YES];
        _glView = [CCGLView viewWithFrame:size pixelFormat:kEAGLColorFormatRGBA8 depthFormat:0];
        /*
        _glView = [CCGLView viewWithFrame:size
                                       pixelFormat:kEAGLColorFormatRGBA8
                                       depthFormat:0	//GL_DEPTH_COMPONENT24_OES
                                preserveBackbuffer:NO
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
         */
                
        _glView.opaque = NO;
        _glView.backgroundColor = [UIColor clearColor];
        
        CALayer* glLayer = [_glView layer];
        glLayer.opaque = NO;
        
        //_glView.alpha = 0.5;
        _glView.backgroundColor = [UIColor clearColor];
        _glView.opaque = NO;    
        
        [director setView:_glView];
    }
    
    return _glView;
}

#pragma mark CCDirectorDelegate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark Singleton

//
// Singleton implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static KTCocos2dEngine* _sharedInstance = nil;


+(KTCocos2dEngine*) sharedInstance
{
    if (_sharedInstance == nil) {
        LOG_OBJ_LIFECYCLE(@"creating sharedInstance");
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

