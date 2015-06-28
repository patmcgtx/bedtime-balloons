//
//  KTBlankSlateRoutineEditor.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/21/14.
//
//

#import "KTBlankSlateRoutineEditor.h"
#import "KTDataAccess.h"
#import "KTConstants.h"
#import "KTTaskPlus.h"
#import "KTRoutinePlus.h"

@interface KTBlankSlateRoutineEditor ()

@property (nonatomic, strong) KTTaskPrototype* customTaskPrototype;

@end

@implementation KTBlankSlateRoutineEditor

- (instancetype)init
{
    self = [super init];
    if (self) {
        _customTaskPrototype = [[[KTDataAccess sharedInstance] taskQueries]
                                getTaskPrototypeByType:kKTThemeNameCustom];
        
    }
    return self;
}

#pragma mark - GMImagePickerController

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    [self saveImagesAsTasks:assets];
    if ( self.delegate ) {
        [self.delegate didFinishEditingRoutine];
    }
}

- (void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker {
    [self cancel];
}

#pragma mark - UIImagePickerControllerDelegate for taking a photo with the camera

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self saveImagesAsTasks:[NSArray arrayWithObject:info]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self cancel];
}

#pragma mark - Internal helpers

-(void) saveImagesAsTasks:(NSArray *)selectedAssets {
    
    NSMutableOrderedSet* tasksToAdd = [NSMutableOrderedSet orderedSetWithCapacity:[selectedAssets count]];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    // See http://nshipster.com/phimagemanager/
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    imageRequestOptions.version = PHImageRequestOptionsVersionCurrent;
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageRequestOptions.synchronous = NO;
    imageRequestOptions.networkAccessAllowed = YES;
    
	for (PHAsset *anAsset in selectedAssets) {
        
        KTTask* taskToAdd = [KTTask taskFromPrototype:self.customTaskPrototype name:@"" commit:YES];
        NSManagedObjectID *addedTaskObjectId = [taskToAdd objectID];
        [tasksToAdd addObject:taskToAdd];
        
        // Kick off an async download of the image for iCloud
        [imageManager requestImageForAsset:anAsset
                                targetSize:screenSize
                               contentMode:PHImageContentModeAspectFit
                                   options:imageRequestOptions
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 // The download completed
                                 KTTask *taskForImage = [[[KTDataAccess sharedInstance] taskQueries] getTaskByObjectId:addedTaskObjectId];
                                 [taskForImage saveCustomImage:result incudingOriginal:YES];
                             }];
    }
    
    [self.routineEntity insertTasksAtBeginning:tasksToAdd commit:YES];
    
    if ( self.delegate ) {
        [self.delegate didInsertTasksAtBeginningOfRoutine:tasksToAdd];
    }
    
    // Let other layers know
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationRoutineTasksDidChange
                                                        object:self
                                                      userInfo:[NSDictionary
                                                                dictionaryWithObject:self.routineEntity
                                                                forKey:KTKeyRoutineEntity]];
}

-(void) cancel {
    if ( self.delegate ) {
        [self.delegate didFinishEditingRoutine];
    }
}

@end
