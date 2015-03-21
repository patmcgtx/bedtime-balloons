//
//  KTPointCount.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTPointCount.h"
#import "KTConstants.h"
#import "RTSAppHelper.h"

@interface KTPointCount ()

@property (nonatomic) int points;

@end

@implementation KTPointCount

@synthesize points = _points;

- (id)initForLayer:(CCLayer*) layer {

    // Will use this as a reference point for sprite layout
    CGRect screenBounds = [[RTSAppHelper sharedInstance] windowBoundsForLandscape:YES
                                                                       forCocos2d:NO];

    self = [super initWithText:@"0"
                      fontName:kKTFontNameRoutineControls
                      fontSize:23.0 
                         color:ccWHITE
                    hAlignment:kCCTextAlignmentRight
                      forLayer:layer
                         atPos:ccp(screenBounds.size.width - 55, 18)
                        atZPos:20 hide:NO]; // Starts out hidden
    
    if (self) {        
        _points = 0;
    }
    
    return self;    
}

/*
-(CCTargetedAction*) appear {
    CCShow* show = [CCShow action];
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.5];
    CCSequence* seq = [CCSequence actions:show, fadeIn, nil];
    return [self actionOnSelf:seq];
}

-(CCTargetedAction*) disappear {
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:0.5];
    CCHide* hide = [CCHide action];
    CCSequence* seq = [CCSequence actions:fadeOut, hide, nil];
    return [self actionOnSelf:seq];
}
*/

#pragma mark - Point management

-(CCTargetedAction*) addPointsForOneBalloon {
    
    CCCallBlock* incrPoints = [CCCallBlock actionWithBlock:(^{
        [self increasePoints:kKTPointsPerBalloon];
    })];
    
    return [CCTargetedAction actionWithTarget:self action:incrPoints];
}


-(int) pointCount {
    return self.points;
}

-(void) increasePoints:(int) additionalPoints {
    self.points += additionalPoints;
    NSString* pointsAsString = [NSString stringWithFormat:@"%i", self.points];
    [self updateTextImmediately:pointsAsString];
}


-(void) displayPercentageScore:(int) percentage {    
    NSString* percentageString = [NSString stringWithFormat:@"%i%%", percentage];
    [self updateTextImmediately:percentageString];
}

@end
