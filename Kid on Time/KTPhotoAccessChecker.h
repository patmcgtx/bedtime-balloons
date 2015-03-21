//
//  KTPhotoAccessChecker.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/24/14.
//
//

#import <Foundation/Foundation.h>

@interface KTPhotoAccessChecker : NSObject

// Returns YES if we shold try accessing photos.
// May display an alert to the user if access is needed.
+(BOOL) vetPhotoAccess;

@end
