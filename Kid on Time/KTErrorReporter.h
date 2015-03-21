//
//  KTErrorReporter.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/7/13.
//
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
//#import "SSErrorReporterFrontEnd.h"

@interface KTErrorReporter : NSObject

@property (nonatomic, weak) UIViewController* rootViewController;

+(KTErrorReporter*) sharedReporter;

/**
 * Warns the user if some feature-impacting event or condition,
 * but allows the app to continue functioning, probably in a
 * limited fashion.  See OTHERE-55.
 *
 * msgKey is the key name of the string to load from a localized
 * strings files.
 *
 * debugInfo provides optional, perhaps non-human-readable, debug
 * information that would ostensibly be reported back to me to
 * help identity specifics of the error.  Can be nil.  One helpful
 * pattern is to simply send in a random string which I can find
 * in the code to see exactly what happened.
 */
-(void) warnUserWithMessageKey:(NSString*) msgKey
                         error:(NSError*) error
                     debugInfo:(NSString*) debugInfo;

@end
