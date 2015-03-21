//
//  KTChalkboardPointCount.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTChalkboardPointCount.h"
#import "KTConstants.h"
#import "RTSAppHelper.h"

@implementation KTChalkboardPointCount

- (id)initForLayer:(CCLayer*) layer withCount:(int) count {

    self = [super initWithText:[NSString stringWithFormat:@"%i", count]
                      fontName:kKTFontNameChalkboard
                      fontSize:23.0 
                         color:ccWHITE
                    hAlignment:kCCTextAlignmentRight
                      forLayer:layer
                         atPos:ccp(440, 18)
                        atZPos:20 hide:NO];
    
    if (self) {        
    }
    
    return self;    
}

#pragma mark - Action generators

-(CCTargetedAction*) moveToChalkboard {
    // We have to wait for a bit to avoid moving into position during the illustration
    // transition.  It does not look good to be moving in the middle of the transition.
    // TODO use a global/#define to make this grab the same time
    // as the task illustration transitions.
    CCDelayTime* wait = [CCDelayTime actionWithDuration:1.0];    
    
    // The position below has to fit into the right spot on the chalkboard in the
    // reward illustration.
    ccBezierConfig bezConfig;
    bezConfig.controlPoint_1  = ccp(365, 285);
    bezConfig.controlPoint_2  = ccp(350, 277);
    
    if ( [[RTSAppHelper sharedInstance] screenResolution] == kRTSScreenResolutioniPhone5 ) {
        bezConfig.endPosition  = ccp(385, 278);
    }
    else {
        bezConfig.endPosition  = ccp(335, 268);
    }
    
    
    
    CCBezierTo* move = [CCBezierTo actionWithDuration:1.25 bezier:bezConfig];
    //CCBezierBy* rewardBez = [CCBezierBy actionWithDuration:0.5 bezier:bezConfig];
    //CCMoveTo* move = [CCMoveTo actionWithDuration:0.75 position:ccp(335, 268)];
    
    // For whatever reason, the "ease" stuff just isn't working right.
    //CCEaseIn* ease = [CCEaseIn actionWithAction:move];
    //CCTargetedAction* easeT = [CCTargetedAction actionWithTarget:self.label action:ease];
    
    // Change to chalkboard font, too
    // can't get this to work.  Probably my best bet is to create another label
    // and send it along to the chalkboard instead.
    //CCCallFunc* changeFont = [self changeFontTo:kKTFontNameChalkboard];
    
    CCSequence* seq = [CCSequence actions:wait, move, nil];
    return [self actionOnSelf:seq];
}

@end
