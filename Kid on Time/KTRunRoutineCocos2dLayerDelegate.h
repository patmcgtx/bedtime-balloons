//
//  KTRunRoutineCocos2dLayerDelegate.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 This delegate protocol is necessary to help with some async
 timing issues between cocos2d and core iOS.
 */
@protocol KTRunRoutineCocos2dLayerDelegate <NSObject>

/*
 Called on the delegate when the cocos2d layer has finished the current
 task and is ready to start the next one.
 */
-(void)readyForNextTask;

// Gives the exact location of the close/cancel button
-(CGPoint) closeButtonCenter;

// We're done with the routine
-(void) exitRoutine;

@end
