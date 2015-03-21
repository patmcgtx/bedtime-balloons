//
//  KTResultDrawing.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTResultDrawing.h"
#import "RTSAppHelper.h"

@implementation KTResultDrawing

- (id)initWithGrade:(KTRoutineGrade) grade 
           ForLayer:(CCLayer*) layer {
    
    NSString* rewardImageName = nil;
    switch (grade) {
            
        case kKTRoutineGradeGood:
            rewardImageName = @"reward-good.png";
            break;
            
        case kKTRoutineGradeMedium:
            rewardImageName = @"reward-medium.png";
            break;
            
        case kKTRoutineGradeBad:
            rewardImageName = @"reward-bad.png";
            break;
            
        default:
            // TODO 
            rewardImageName = @"reward-good.png";
            break;
    }

    CGPoint pos;
    if ( [[RTSAppHelper sharedInstance] screenResolution] == kRTSScreenResolutioniPhone5 ) {
        pos.x = 425;
        pos.y = 250;
    }
    else {
        pos.x = 360;
        pos.y = 240;
    }
    
    // Start out off the right side of the screen, to come on later
    self = [super initWithFile:rewardImageName
                      forLayer:layer
                         atPos:pos
                        atZPos:100
                          hide:YES];
    
    if (self) {        
    }
    return self;
}

@end
