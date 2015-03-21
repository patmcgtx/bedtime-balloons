//
//  RTSCorner.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTSCorner.h"

RTSCorner randomCornerNotUpperRight(void) {
    
    RTSCorner retval;
    
    int rand1to3 = arc4random() % 3 + 1;
    
    switch (rand1to3) {
        case 1:
            retval = kRTSCornerLowerLeft;
            break;
        case 2:
            retval = kRTSCornerLowerRight;
            break;
        case 3:
            retval = kRTSCornerUpperRight;
            break;            
        default:
            // Should not happen, but just in case
            retval = kRTSCornerLowerLeft;
            break;
    }
    
    return retval;
}
