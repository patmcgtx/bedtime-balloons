//
//  KTNewRoutineELCImagePickerDelegate.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/8/14.
//
//

#import "KTBlankSlateRoutineCreator.h"
#import "KTConstants.h"
#import "KTDataAccess.h"
#import "KTRoutine.h"
#import "KTTaskPlus.h"
#import "KTTaskBasePlus.h"
#import "KTRoutinePlus.h"
#import "KTTaskPlus.h"

@interface KTBlankSlateRoutineCreator ()

@property (nonatomic, strong) KTTaskPrototype* customTaskPrototype;

@end

@implementation KTBlankSlateRoutineCreator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _customTaskPrototype = [[[KTDataAccess sharedInstance] taskQueries]
                                getTaskPrototypeByType:kKTThemeNameCustom];
    }
    return self;
}

#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)selectImageInfo {
    
    if ( ! self.routineName ) {
        self.routineName = NSLocalizedString(@"routine.name.default", nil);
    }
    
    // Add the selected images to the routine as cutom tasks
    NSMutableOrderedSet* tasksToAdd = [NSMutableOrderedSet orderedSetWithCapacity:[selectImageInfo count]];

    // To map tasks to images
    NSMutableArray* taskImagesArray = [NSMutableArray arrayWithCapacity:[selectImageInfo count]];
    
	for (NSDictionary* imageDict in selectImageInfo) {
        
        KTTask* taskToAdd = [KTTask taskFromPrototype:self.customTaskPrototype name:@"" commit:NO];
        [tasksToAdd addObject:taskToAdd];
        
        // Save task image later -- see notes below...
        UIImage* image = [imageDict objectForKey:UIImagePickerControllerOriginalImage];
        [taskImagesArray addObject:image];
    }
        
    // Create the routine
    KTRoutine* routine = [KTRoutine routineWithName:self.routineName themeName:kKTThemeNameCustom tasks:tasksToAdd commit:YES];
    
    // We have to save the task images ~after~ commiting to the db so that that filename
    // comes out right.  The file name depends on the task's URIRepresentation which is
    // only good if the task is committed to the db.
    // Do this in the background too, since it can take some time.
    
    if ( self.delegate ) {
        [self.delegate didFinishRoutineCreation:routine];
    }
    
    // Do this in the background since it can take a while (x several tasks)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        int imageIndex = 0;
        for (KTTask* savedTask in routine.tasks) {
            UIImage* imageToSave = (UIImage*) [taskImagesArray objectAtIndex:imageIndex++];
            [savedTask saveCustomImage:imageToSave incudingOriginal:YES];
        }
    });

}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    
    if ( self.delegate ) {
        [self.delegate didCancelRoutineCreation];
    }
}

@end
