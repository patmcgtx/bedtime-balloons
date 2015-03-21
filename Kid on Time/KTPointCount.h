//
//  KTPointCount.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTCocos2dLabel.h"

@interface KTPointCount : KTCocos2dLabel

- (id)initForLayer:(CCLayer*) layer;

/*
 Actions to fade the point counter in and out
 */
//-(CCTargetedAction*) appear;
//-(CCTargetedAction*) disappear;

/*
 Creates an action to add one balloon's worth of points
 to the counter.
 */
-(CCTargetedAction*) addPointsForOneBalloon;

/*
 Adds a points to the counter, and displays the new total.
 */
-(void) increasePoints:(int) additionalPoints;

/*
 What is the current value of the point count?
 */
-(int) pointCount;

/*
 Changes this element to display a % score instead of point count
 */
-(void) displayPercentageScore:(int) percentage;

@end
