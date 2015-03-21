//
//  OTPausable.h
//  OverThere
//
//  Created by Patrick McGonigle on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Denotes an obect which can be temporaily inactivated and then reactivated
 * later.
 */
@protocol RTSPausable <NSObject>

/**
 * Pauses this object's activity, ratcheting down resource-intensive things
 * such as animations, batch jobs, and multimedia.
 */
- (void) pause;

/**
 * Undoes -pause, reactivating this view in its full glory.
 */
- (void) resume;

@end
