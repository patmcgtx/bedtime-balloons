//
//  KTRoutineTaskPIckerController.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/18/14.
//
//

#import <UIKit/UIKit.h>
#import "KTRoutineAddTasksBaseController.h"

@interface KTNewRoutineTaskPickerController : KTRoutineAddTasksBaseController

// Set on segue when by when creating a new routine
@property (strong, nonatomic) NSString* createRoutineName;
@property (strong, nonatomic) NSString* createRoutineThemeName;

@end
