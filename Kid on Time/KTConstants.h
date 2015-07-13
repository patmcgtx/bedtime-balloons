//
//  KTConstants.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Kid_on_Time_KTConstants_h
#define Kid_on_Time_KTConstants_h

//
// Fundamental constants
//

#define kKTPointsPerBalloon 1
#define kKTBalloonsPerTask 6
#define kKTMaxNumRewardBalloons 12.0
#define kKTMaxTaskTimeInMins 60.0f

//
// Resources
//

// Images
#define kKTMissingImageName @"task-loading"

// Fonts
#define kKTFontNameRoutineControls @"Thonburi"
#define kKTFontNameChalkboard @"Chalkduster"
#define kKTPointsPerBalloonText @"1"

// Custom image zooming
#define kKTUserImageMinZoomScale 0.75;
#define kKTUserImageMaxZoomScale 3.0

//
// Themes
//

#define kKTThemeNameDefault @"default"
#define kKTThemeNameCustom @"custom"


//
// Notifications
//

// The application enters/returns from background
#define KTNotificationAppDidEnterBackground @"KTNotificationAppDidEnterBackground"
#define KTNotificationAppWillEnterForeground @"KTNotificationAppWillEnterForeground"

// Refresh notifications
#define KTNotificationRoutineNameDidChange @"KTNotificationRoutineNameDidChange"
#define KTNotificationRoutineTasksDidChange @"KTNotificationRoutineTasksDidChange" // Number or order of a routine's tasks changed
#define KTNotificationTaskNameDidChange @"KTNotificationTaskNameDidChange"
#define KTNotificationTaskImageDidChange @"KTNotificationTaskImageDidChange"
#define KTNotificationTaskImageDownloadFailed @"KTNotificationTaskImageDownloadFailed"
//#define KTNotificationTaskImageDownloadStarted @"KTNotificationTaskImageDownloadStarted"
#define KTNotificationDidDeleteRoutine @"KTNotificationDidDeleteRoutine"
#define KTNotificationDidAddRoutine @"KTNotificationDidAddRoutine"
#define KTNotificationDidDeleteTask @"KTNotificationDidDeleteTask"
#define KTNotificationDidAddTasksToRoutine @"KTNotificationDidAddTasksToRoutine" // In addition to KTNotificationRoutineTasksDidChange for new tasks
#define KTNotificationRewardBalloonPopped @"KTNotificationRewardBalloonPopped"

// Action request notifications (to avoid tight coupling in some cases)
#define KTNotificationDoPresentActionSheet @"KTNotificationDoPresentActionSheet"

//
// Notification data keys
//

#define KTKeyRoutineEntity @"KTKeyRoutineEntity"
#define KTKeyTaskEntity @"KTKeyTaskEntity"
#define KTKeyDeletedObjectIndex @"KTKeyDeletedObjectIndex"
#define KTKeyActionSheet @"KTKeyActionSheet"
#define KTKeyNumberOfItems @"KTKeyNumberOfItems" // NSNumber

//
// Image picker
//

#define KTImagePickerMaxImages 20        // The maximum number of images to select
#define KTImagePickerReturnsOriginal NO  // Only return the fullScreenImage, not the fullResolutionImage

#endif
