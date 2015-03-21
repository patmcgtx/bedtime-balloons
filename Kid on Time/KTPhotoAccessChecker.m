//
//  KTPhotoAccessChecker.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/24/14.
//
//

#import "KTPhotoAccessChecker.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation KTPhotoAccessChecker

+(BOOL) vetPhotoAccess {
    
    BOOL retval = NO;
    
    ALAuthorizationStatus photoAuth = [ALAssetsLibrary authorizationStatus];
    
    if ( photoAuth == ALAuthorizationStatusAuthorized || photoAuth == ALAuthorizationStatusNotDetermined ) {
        retval = YES;
    }
    else if ( photoAuth == ALAuthorizationStatusDenied ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"photo.accessdenied.label", nil)
                                                        message:NSLocalizedString(@"photo.accessdenied.message", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"label.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    return retval;
}

@end
