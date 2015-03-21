//
//  OTUIApplication.m
//  OverThere
//
//  Created by Patrick McGonigle on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KTErrorReporter.h"
#import "RTSLog.h"
#import "KTErrorReporterController.h"

@interface KTErrorReporter ()

@property (nonatomic, strong) NSMutableSet* errorMessagesAlreadyShown;

@end

@implementation KTErrorReporter

-(void) warnUserWithMessageKey:(NSString*) msgKey
                         error:(NSError*) error
                     debugInfo:(NSString *)debugInfo {
    
    // Log it
    if ( debugInfo ) {
        LOG_USER_WARNING(@"%@ [%@]", NSLocalizedString(msgKey, nil), debugInfo);
    }
    else {
        LOG_USER_WARNING(NSLocalizedString(msgKey, nil));
    }
    
    if ( error ) {
        LOG_USER_WARNING(@"%@ [%@]", msgKey, [error localizedDescription]);
        LOG_USER_WARNING(@"%@ [%@]", msgKey, [error localizedRecoverySuggestion]);
        LOG_USER_WARNING(@"%@ [%@]", msgKey, [error localizedRecoveryOptions]);
        LOG_USER_WARNING(@"%@ [%@]", msgKey, [error localizedFailureReason]);
    }
    
    // And send it on to the front end as possible
    if ( self.rootViewController ) {
        
        if ( self.rootViewController.storyboard ) {
            
            KTErrorReporterController* errorReporterController = [self.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"KTErrorReporterController"];
            
            if ( errorReporterController ) {
                
                // But avoid annoying repeated warnings
                if ( ! [self.errorMessagesAlreadyShown containsObject:msgKey] ) {
                    
                    errorReporterController.userErrorMessage = NSLocalizedString(msgKey, nil);
                    [self.rootViewController presentViewController:errorReporterController animated:YES completion:nil];
                    
                    // Don't show again
                    [self.errorMessagesAlreadyShown addObject:msgKey];
                }
            }
        }
    }
}


#pragma mark Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static KTErrorReporter* sSharedErrorReporter = nil;


+(KTErrorReporter*) sharedReporter
{
    if (sSharedErrorReporter == nil) {
        sSharedErrorReporter = [[super allocWithZone:NULL] init];
        sSharedErrorReporter.errorMessagesAlreadyShown = [NSMutableSet set];
    }
    return sSharedErrorReporter;
}


+(id) allocWithZone:(NSZone*) zone
{
    return [self sharedReporter];
}


-(id) copyWithZone:(NSZone*) zone
{
    return self;
}

@end
