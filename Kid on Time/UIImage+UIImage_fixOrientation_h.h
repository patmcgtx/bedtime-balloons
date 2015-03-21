//
//  UIImage+UIImage_fixOrientation_h.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/16/13.
//
//

#import <UIKit/UIKit.h>

//
// See http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
// for KIDSCHED-255 Sometimes custom pictures are rotated 90 degrees
//

@interface UIImage (UIImage_fixOrientation_h)

- (UIImage *)fixOrientation;

@end
