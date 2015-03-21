//
//  RTSkdjsakdjsa.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/24/14.
//
//

#import "RTSImageSize.h"

NSString* rtsImageSizeAsString(RTSImageSize imageSize) {
    
    NSString* retval = nil;
    
    switch (imageSize) {
        case RTSImageSizeSmall:
            retval = @"sm";
            break;

        case RTSImageSizeMedium:
            retval = @"md";
            break;

        case RTSImageSizeLarge:
            retval = @"lg";
            break;
            
        case RTSImageSizeScreen:
            retval = @"screen";
            break;

        case RTSImageSizeOriginal:
            retval = @"orig";
            break;
    }
    
    return retval;
}

