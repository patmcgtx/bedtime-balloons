//
//  KTBlankSlateRoutineEditor.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/21/14.
//
//

#import <Foundation/Foundation.h>
#import "GMImagePickerController.h"
#import "KTEditRoutineDelegate.h"
#import "KTRoutine.h"
#import "GMImagePickerController.h"

@interface KTBlankSlateRoutineEditor : NSObject <GMImagePickerControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) id<KTEditRoutineDelegate> delegate;
@property (strong, nonatomic) KTRoutine* routineEntity;

@end
