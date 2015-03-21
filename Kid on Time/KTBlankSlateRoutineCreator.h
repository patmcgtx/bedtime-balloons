//
//  KTNewRoutineELCImagePickerDelegate.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/8/14.
//
//

#import <Foundation/Foundation.h>
#import "KTCreateRoutineDelegate.h"
#import "ELCImagePickerController.h"

@interface KTBlankSlateRoutineCreator : NSObject <ELCImagePickerControllerDelegate>

@property (weak, nonatomic) id<KTCreateRoutineDelegate> delegate;

@property (strong, nonatomic) NSString* routineName;

@end
