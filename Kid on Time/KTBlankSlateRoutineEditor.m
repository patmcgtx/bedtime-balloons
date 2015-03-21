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

#pragma mark - ELCImagePickerControllerDelegate for selecting photos from the library

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)selectImageInfo {
    [self saveImagesAsTasks:selectImageInfo];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
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

-(void) saveImagesAsTasks:(NSArray *)selectImageInfo {
    
    NSMutableOrderedSet* tasksToAdd = [NSMutableOrderedSet orderedSetWithCapacity:[selectImageInfo count]];
    
    // To map tasks to images
    NSMutableArray* imagesForTasksToAdd = [NSMutableArray arrayWithCapacity:[selectImageInfo count]];
    
	for (NSDictionary* imageDict in selectImageInfo) {
        
        KTTask* taskToAdd = [KTTask taskFromPrototype:self.customTaskPrototype name:@"" commit:NO];
        [tasksToAdd addObject:taskToAdd];
        
        // Save task image later -- see notes below...
        UIImage* image = [imageDict objectForKey:UIImagePickerControllerOriginalImage];
        [imagesForTasksToAdd addObject:image];
    }
    
    [self.routineEntity insertTasksAtBeginning:tasksToAdd commit:YES];
    
    // We have to save the task images ~after~ commiting to the db so that that filename
    // comes out right.  The file name depends on the task's URIRepresentation which is
    // only good if the task is committed to the db.
    // Do this in the background since it can take a while (x several tasks)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        int imageIndex = 0;
        for (KTTask* savedTask in tasksToAdd) {
            UIImage* imageToSave = (UIImage*) [imagesForTasksToAdd objectAtIndex:imageIndex++];
            [savedTask saveCustomImage:imageToSave incudingOriginal:YES];
        }
    });
    
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
        [self.delegate didCancelEditingRoutine];
    }
}

@end
