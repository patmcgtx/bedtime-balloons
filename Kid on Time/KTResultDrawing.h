//
//  KTResultDrawing.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTCocos2dSprite.h"
#import "KTCocos2dSprite.h"
#import "KTRoutineGrade.h"

@interface KTResultDrawing : KTCocos2dSprite

/*
 Creates the "drawing" and adds it to the given cocos2d layer
 */
- (id)initWithGrade:(KTRoutineGrade) grade 
           ForLayer:(CCLayer*) layer;

@end
