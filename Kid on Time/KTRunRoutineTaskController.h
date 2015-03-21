//
//  KTRunRoutineTaskController.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTRoutine.h"
#import "cocos2d.h"
#import "KTRoutineAnimationsDelegate.h"

@interface KTRunRoutineTaskController : UIViewController <KTRoutineAnimationsDelegate>

@property (nonatomic) NSInteger activeTaskNum;
@property (nonatomic, strong) KTRoutine* routineEntity;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoView;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoViewiPhone5;
@property (weak, nonatomic) IBOutlet UIImageView *baloonIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *pauseOverlay;
@property (weak, nonatomic) IBOutlet UILabel *minTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *minTimerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoBlankSlate;

- (IBAction)stopRoutine:(id)sender;
- (IBAction)doneWithTask:(id)sender;
- (IBAction)pauseRoutine:(id)sender;
- (IBAction)resumeRoutine:(id)sender;

@end
