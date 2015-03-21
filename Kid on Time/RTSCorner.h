//
//  RTSCorner.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Kid_on_Time_RTSCorner_h
#define Kid_on_Time_RTSCorner_h

typedef enum {
    kRTSCornerNone = 0,
    kRTSCornerLowerLeft = 1,
    kRTSCornerUpperLeft = 2,
    kRTSCornerUpperRight = 3,
    kRTSCornerLowerRight = 4
} RTSCorner;

/*
 Picks a random corner, excluding the possiblility of upper-right.
 */
RTSCorner randomCornerNotUpperRight(void);

#endif
