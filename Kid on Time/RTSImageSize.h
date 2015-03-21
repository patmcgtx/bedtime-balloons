//
//  RTSImageSize.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/24/14.
//
//

#ifndef Kid_on_Time_RTSImageSize_h
#define Kid_on_Time_RTSImageSize_h

typedef enum {
    RTSImageSizeSmall  = 0,  // ie 58 x 58 px
    RTSImageSizeMedium = 1,  // ie 133 x 130 px
    RTSImageSizeLarge  = 2,  // ie 280 x 210 px
    RTSImageSizeScreen   = 3,  // Screen size, for viewing in the routine
    RTSImageSizeOriginal = 4   // Full original size
} RTSImageSize;

NSString* rtsImageSizeAsString(RTSImageSize imageSize);

#endif
