//
//  OTLandmarkHUDCocosMgr.h
//  OverThere
//
//  Created by Patrick McGonigle on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RTSPausable.h"

/**
 * This singleton encapsulates the cocos2d engine to make it easier
 * for my app to manage.  When the singleton is initialized, the
 * cocos2d engine is initialized.  When it is cleaned up,
 * cocosd is cleaned up.  When it is paused or resumed,
 * cocos2d is pasued/resumed.  
 *
 * The cocos2d view that is generated is specialized for this app.
 * For instance, the background is transparent, and it fits this
 * app's window size and orientation.
 *
 * This engine sets up the cocos2d director and EAGLView, but
 * it does not create or run a scene.
 */
@interface KTCocos2dEngine : NSObject <RTSPausable, CCDirectorDelegate>
{
    CCGLView* _glView;
}

/**
 * Gets the singleton instance
 */ 
+(KTCocos2dEngine*) sharedInstance;

/**
 * Retrieves (first creating if necessary) the UIView instance for
 * the cocos2d engine.
 */
-(CCGLView*) view;

/**
 * Purges cocos2d cached data, for memory cleanup, but continue
 * to function as normal.
 */
-(void) purge;

/**
 * Stops the cocos2d engine cold, ie on app termination.
 */
-(void) stop;

/**
 * This is basically here to help with -applicationSignificantTimeChange
 * calls on the app delegate
 */
-(void) significantTimeChange;


@end
