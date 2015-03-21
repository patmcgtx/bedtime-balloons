//
//  OTAppHelper.h
//  OverThere
//
//  Created by Patrick McGonigle on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTSScreenResolution.h"

@interface RTSAppHelper : NSObject

/**
 * Gets the singleton instance
 */
+(RTSAppHelper*) sharedInstance;


-(CGRect) windowBoundsForLandscape:(BOOL)forLandscape forCocos2d:(BOOL)forCocos2d;

-(UIWindow*) appWindow;

-(NSURL *)applicationDocumentsDirectory;

// Determines if this is 3.5" (iPhone 4) or 4" (iPhone 5)
-(RTSScreenResolution) screenResolution;

-(BOOL) isRetinaDisplay;

@end
