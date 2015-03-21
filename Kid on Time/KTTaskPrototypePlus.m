//
//  KTTaskPrototypePlus.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/24/14.
//
//

#import "KTTaskPrototypePlus.h"
#import "KTConstants.h"
#import "RTSLog.h"
#import "KTDataAccess.h"

@implementation KTTaskPrototype (plusMethods)

-(UIImage*) closeupForTheme:(NSString*) themeName withSize:(RTSImageSize) imageSize {
    
    NSString* imageFileName = [NSString stringWithFormat:@"theme-%@-%@-closeup-%@",
                               themeName, self.type, rtsImageSizeAsString(imageSize)];
    UIImage* retval = [UIImage imageNamed:imageFileName];
    
    if ( ! retval ) {
        // Hmm, failed to load the thumbnail, use a placeholder
        LOG_INTERNAL_ERROR(@"Failed to load close-up image file %@", imageFileName);
        retval = [UIImage imageNamed:kKTMissingImageName];
    }
    
    return retval;
}

+(KTTaskPrototype*) taskPrototype {

    NSManagedObjectContext* ctx = [[KTDataAccess sharedInstance] managedObjectContext];
    
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"TaskPrototype"
            inManagedObjectContext:ctx];
}

@end
