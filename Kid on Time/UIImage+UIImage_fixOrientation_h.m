//
//  UIImage+UIImage_fixOrientation_h.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/16/13.
//
//

#import "UIImage+UIImage_fixOrientation_h.h"

@implementation UIImage (UIImage_fixOrientation_h)

- (UIImage *)fixOrientation {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


@end

