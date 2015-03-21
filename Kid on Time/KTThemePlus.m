//
//  KTTheme+KTThemePlus.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/16/13.
//
//

#import "KTThemePlus.h"
#import "KTConstants.h"
#import "RTSLog.h"
#import "KTDataAccess.h"

@implementation KTTheme (plusMethods)

+(KTTheme*) themeWithName:(NSString*) themeName dislpayOrder:(NSUInteger) displayOrder commit:(BOOL) doCommit {

    NSManagedObjectContext* ctx = [[KTDataAccess sharedInstance] managedObjectContext];
    
    KTTheme* retval = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Theme"
                       inManagedObjectContext:ctx];

    retval.nameKey = themeName;
    retval.displayOrder = [NSNumber numberWithUnsignedLong:displayOrder];
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
    
    return retval;
}

-(BOOL) isDefaultTheme {
    return [self.nameKey isEqualToString:kKTThemeNameDefault];
}

-(BOOL) isCustomTheme {
    return [self.nameKey isEqualToString:kKTThemeNameCustom];
}

-(NSString*) localizedName {
    // Look up a string from Localizable.strings with a key such as "theme.default.name"
    NSString* stringsFileKeyName = [NSString stringWithFormat:@"theme.%@.name", self.nameKey];
    return NSLocalizedString(stringsFileKeyName, @"");
}

-(NSString*) localizedDescription {
    // Look up a string from Localizable.strings with a key such as "theme.default.description"
    NSString* stringsFileKeyName = [NSString stringWithFormat:@"theme.%@.description", self.nameKey];
    return NSLocalizedString(stringsFileKeyName, @"");
}

-(UIImage*) thumbnail {
    
    NSString* imageFileName = [NSString
                               stringWithFormat:@"theme-%@-thumbnail",
                               self.nameKey];
    
    UIImage* retval = [UIImage imageNamed:imageFileName];

    if ( ! retval ) {
        LOG_INTERNAL_ERROR(@"Failed to load thumbnail theme %@", self.nameKey);
        retval = [UIImage imageNamed:kKTMissingImageName];
    }
    
    return retval;
}

@end
