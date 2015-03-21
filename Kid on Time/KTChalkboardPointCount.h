//
//  KTChalkboardPointCount.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTCocos2dLabel.h"

/*
 This label will appear at the end of the reward sequence
 and put the final score on the chalkboard
 */
@interface KTChalkboardPointCount : KTCocos2dLabel

- (id)initForLayer:(CCLayer*) layer withCount:(int) count;

/*
 Creates an action to move into position on the chalkboard
 */
-(CCTargetedAction*) moveToChalkboard;

@end
