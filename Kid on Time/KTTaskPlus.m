//
//  KTTaskPlus.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTaskPlus.h"
#import "KTTaskBasePlus.h"
#import "RTSAppHelper.h"
#import "UIImage+UIImage_fixOrientation_h.h"
#import "KTConstants.h"
#import "KTRoutinePlus.h"
#import "KTTheme.h"
#import "RTSTimeUtils.h"
#import "UIImage+ResizeMagick.h"
#import "KTDataAccess.h"

@implementation  KTTask (plusMethods)

+(KTTask*) task {
    
    NSManagedObjectContext* ctx = [[KTDataAccess sharedInstance] managedObjectContext];
    
    KTTask* retval = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Task"
                      inManagedObjectContext:ctx];

    return retval;
}

+(KTTask*) taskFromPrototype:(KTTaskPrototype*) prototype commit:(BOOL) doCommit {
    
    KTTask* retval = [KTTask task];
    
    retval.type = prototype.type;
    retval.name = prototype.name;
    retval.timeInSeconds = prototype.timeInSeconds;
    retval.minTimeInSeconds = prototype.minTimeInSeconds;
    
    if ( doCommit ) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
    
    return retval;
}

+(KTTask*) taskFromPrototype:(KTTaskPrototype*) prototype name:(NSString*) taskName commit:(BOOL) doCommit {
    
    KTTask* retval = [KTTask taskFromPrototype:prototype commit:NO];
    retval.name = taskName;
    
    if (doCommit) {
        [[KTDataAccess sharedInstance] commitChanges];
    }
    
    return retval;
}

-(UIImage*) imageWithSize:(RTSImageSize) imageSize {

    UIImage* retval = nil;
    
    if ( self.isCustomTask ) {
        // The custom images are saved to the <APPHOME>/Documents dir and have to be loaded by explicit path
        retval = [UIImage imageWithContentsOfFile:[self pathForCustomImageWithSize:imageSize]];
    }
    else {
        
        // The built-in images are pre-packaed in the application bundle and can be loaded by image name,
        // avoiding the whole Retina check to boot.
        NSString* imageFileName = nil;
        
        if ( imageSize == RTSImageSizeScreen ) {
            // Grab the first image from the list of anmated frames
            imageFileName = [NSString stringWithFormat:@"theme-%@-%@-0",
                                       self.routine.theme.nameKey, self.type];
        }
        else {
            // Grab the right preview size
            imageFileName = [NSString stringWithFormat:@"theme-%@-%@-preview-%@",
                                       self.routine.theme.nameKey, self.type, rtsImageSizeAsString(imageSize)];
        }
        
        retval = [UIImage imageNamed:imageFileName];
    }

    /*
    if ( ! retval ) {
        retval = [UIImage imageNamed:kKTMissingImageName];
    }
     */
    
    return retval;
}

//-(UIImage*) placeholderImage {
//    
//    UIImage* retval = nil;
//    
//    if ( self.isCustomTask ) {
//        retval = [UIImage imageWithContentsOfFile:[self pathForPlaceholderImage]];
//    }
//    
//    return retval;
//}

-(void) deleteCustomImages {
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    // Not handling errors because what would we do anyways?
    [fileManager removeItemAtPath:[self pathForCustomImageWithSize:RTSImageSizeOriginal] error:nil];
    [fileManager removeItemAtPath:[self pathForCustomImageWithSize:RTSImageSizeScreen] error:nil];
    [fileManager removeItemAtPath:[self pathForCustomImageWithSize:RTSImageSizeSmall] error:nil];
    [fileManager removeItemAtPath:[self pathForCustomImageWithSize:RTSImageSizeMedium] error:nil];
    [fileManager removeItemAtPath:[self pathForCustomImageWithSize:RTSImageSizeLarge] error:nil];    
}

-(void) saveCustomImage:(UIImage*) customImage incudingOriginal:(BOOL) saveOriginal {

    if ( customImage ) {
        
        // Sometimes have to fix the orientation as per KIDSCHED-255
        UIImage* baseImage = [customImage fixOrientation];
        
        if ( saveOriginal ) {
            // Save the original, full-size image to disk
            [UIImagePNGRepresentation(baseImage) writeToFile:[self pathForCustomImageWithSize:RTSImageSizeOriginal] atomically:YES];
        }
        
        // Save a full-screen verion.
        // This basically assumes Retina, which I think is fair since we're on iOS7+.
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        int screenWidth = (int)screenBounds.size.width * [[UIScreen mainScreen] scale];
        int screenHeight = (int)screenBounds.size.height * [[UIScreen mainScreen] scale];

        // Flip width/height for landscape mode
        UIImage* preview = [baseImage resizedImageByMagick: [NSString stringWithFormat:@"%ix%i#", screenHeight, screenWidth]];
        [UIImagePNGRepresentation(preview) writeToFile:[self pathForCustomImageWithSize:RTSImageSizeScreen] atomically:YES];
        
        // Save the smaller preview sizes too
        preview = [baseImage resizedImageByMagick: @"116x116#"];
        [UIImagePNGRepresentation(preview) writeToFile:[self pathForCustomImageWithSize:RTSImageSizeSmall] atomically:YES];
        
        preview = [baseImage resizedImageByMagick: @"266x260#"];
        [UIImagePNGRepresentation(preview) writeToFile:[self pathForCustomImageWithSize:RTSImageSizeMedium] atomically:YES];
        
        preview = [baseImage resizedImageByMagick: @"560x420#"];
        [UIImagePNGRepresentation(preview) writeToFile:[self pathForCustomImageWithSize:RTSImageSizeLarge] atomically:YES];
        
        // Let the task listeners know when the images are ready
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationTaskImageDidChange
                                                            object:self];        
    }
}

//-(void) savePlaceholderImage:(UIImage*) placeholderImage {
//
//    [UIImagePNGRepresentation(placeholderImage) writeToFile:[self pathForPlaceholderImage] atomically:YES];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationTaskPlaceholderImageDidChange
//                                                        object:self];
//}

-(BOOL) mayebUpdateName:(NSString*) taskName minTimeInSecs:(NSUInteger) minSecs maxTimeInSecs:(NSUInteger) maxSecs commit:(BOOL) doCommit {
    
    BOOL taskHasChanged = (! [taskName isEqualToString:self.name]
                           || minSecs != [self.minTimeInSeconds unsignedIntegerValue]
                           || maxSecs != [self.timeInSeconds unsignedIntegerValue] );
    
    if ( taskHasChanged ) {
        
        self.name = taskName;
        self.minTimeInSeconds = [NSNumber numberWithUnsignedLong:minSecs];
        self.timeInSeconds = [NSNumber numberWithUnsignedLong:maxSecs];
        
        if (doCommit) {
            [[KTDataAccess sharedInstance] commitChanges];
        }
    }
    
    return taskHasChanged;
}

-(NSUInteger) minTimeInMinutes {
    NSUInteger secs = [self.minTimeInSeconds unsignedIntegerValue];
    return secs / 60;
}

-(NSUInteger) maxTimeInMinutes {
    NSUInteger secs = [self.timeInSeconds unsignedIntegerValue];
    return secs / 60;
}

-(KTTask*) nextTask {
    return  [self.routine taskAfter:self];
}

-(KTTask*) previousTask {
    return  [self.routine taskBefore:self];
}

-(NSUInteger) indexWithinRoutine {
    NSAssert(self.routine, @"task has no routine when getting its index");
    return [self.routine.tasks indexOfObject:self];
}

#pragma mark - Internal helpers

//
// This is the file path where we save custom images.  We put it under the <Application_Home>/Documents
// directory so that it (1) gets backed up to iCloud, etc., and (2) gets copied over when the
// app is upgraded.
//
-(NSString*) pathForCustomImageWithSize:(RTSImageSize) imageSize {

    // Since we're running iOS 7+, we're assuming Retina @2x support
    NSString* retval = nil;
    
    if ( [self isCustomTask] ) {
        
        // e.g. custom-image-p46-full@2x.png
        NSString* pngFileName = [NSString stringWithFormat:@"custom-image-%@-%@@2x.png",
                                 [self shortId], rtsImageSizeAsString(imageSize)];
        
        // e.g. /var/mobile/Applications/B3C2AAB7-4BF1-46A3-A45C-3DDDB92390ED/Documents
        NSString* docsDirPath = [[[RTSAppHelper sharedInstance] applicationDocumentsDirectory] path];
        
        // e.g. /var/mobile/Applications/B3C2AAB7-4BF1-46A3-A45C-3DDDB92390ED/Documents/custom-image-p11-sm.png
        retval = [docsDirPath stringByAppendingPathComponent:pngFileName];
    }
    
    return retval;
}

//-(NSString*) pathForPlaceholderImage {
//    
//    NSString* retval = nil;
//    
//    if ( [self isCustomTask] ) {
//        
//        // e.g. placeholder-image-p46@2x.png
//        NSString* pngFileName = [NSString stringWithFormat:@"placeholder-image-%@-@2x.png", [self shortId]];
//        
//        // e.g. /var/mobile/Applications/B3C2AAB7-4BF1-46A3-A45C-3DDDB92390ED/Documents
//        NSString* docsDirPath = [[[RTSAppHelper sharedInstance] applicationDocumentsDirectory] path];
//        
//        // e.g. /var/mobile/Applications/B3C2AAB7-4BF1-46A3-A45C-3DDDB92390ED/Documents/custom-image-p11-sm.png
//        retval = [docsDirPath stringByAppendingPathComponent:pngFileName];
//    }
//    
//    return retval;
//}

@end
