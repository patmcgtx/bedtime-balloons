//
//  KTRunRoutineTaskController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTRunRoutineTaskController.h"
#import "KTCocos2dEngine.h"
#import "KTTheme.h"
#import "KTTask.h"
#import "KTTaskBasePlus.h"
#import "KTTaskPlus.h"
#import "KTSoundPlayer.h"
#import "RTSAppHelper.h"
#import "KTConstants.h"
#import "KTTaskNotifiication.h"
#import "KTRoutineAnimationsLayer.h"
#import "KTThemePlus.h"
#import "RTSLog.h"

@interface KTRunRoutineTaskController ()

@property (strong, nonatomic) CCScene* cocos2dScene;
@property (strong, nonatomic) CCGLView* cocos2dView;
@property (strong, nonatomic) KTRoutineAnimationsLayer* animationLayer;
@property (strong, nonatomic) KTTaskNotifiication* bgTimeWarningNotifiction;
@property (strong, nonatomic) NSDate* whenTaskStarted;
@property (strong, nonatomic) NSDate* whenTaskPaused;
@property (strong, nonatomic) NSDate* whenTaskScheduledToFinish;
@property (strong, nonatomic) NSDate* firstWarningTime;
@property (strong, nonatomic) NSDate* secondWarningTime;
@property (strong, nonatomic) NSDate* finalCountdownTime;
@property (strong, nonatomic) NSDate* whenMinTimeFinished;
@property (strong, nonatomic) NSDate* whenWentToBg;
@property (strong, nonatomic)  NSTimer* maxTimeLabelUpdater;
@property (strong, nonatomic)  NSTimer* minTimeLabelUpdater;
@property (strong, nonatomic)  NSTimer* villainPoppingTimer;
@property (strong, nonatomic)  NSTimer* cancelVillainVisitTimer;
@property (strong, nonatomic)  NSTimer* villainVisitTimer;
@property (nonatomic) BOOL villainStartedPoppingForThisTask;

@end

//
// Privat (sort of) internal interface
//
@interface KTRunRoutineTaskController (hidden)

-(void) incrementTaskNum;
-(void) presentNextTask;
-(KTTask*) currentTask;
-(void) presentReward;
-(void) initCocos2dLayer;
-(void) scheduleJobs;
-(void) cancelScheduledJobsWithLocalNotifications:(BOOL) inclLocNots;
-(void) adjustViewForCustomRoutine;
-(void) hideOrShowTimeLimitControls;
-(void) calculateTiming;
-(void) actuallyStopRoutine;

@end


@implementation KTRunRoutineTaskController

@synthesize activeTaskNum;
@synthesize routineEntity;
@synthesize cancelButton;
@synthesize pageControl;
@synthesize doneButton;
@synthesize taskImageView;
@synthesize activityIndicator;
@synthesize userPhotoView;

@synthesize bgTimeWarningNotifiction = _bgTimeWarningNotifiction;
@synthesize whenTaskStarted = _whenTaskStarted;
@synthesize whenTaskPaused = _whenTaskPaused;
@synthesize whenTaskScheduledToFinish = _whenTaskScheduledToFinish;
@synthesize maxTimeLabelUpdater = _maxTimeLabelUpdater;
@synthesize firstWarningTime = _firstWarningTime;
@synthesize secondWarningTime = _secondWarningTime;
@synthesize finalCountdownTime = _finalCountdownTime;
@synthesize whenMinTimeFinished = _enableNextButtonTime;
@synthesize whenWentToBg = _whenWentToBg;
@synthesize villainPoppingTimer = _villainPoppingTimer;
@synthesize cancelVillainVisitTimer = _cancelVillainVisitTimer;
@synthesize villainVisitTimer = _villainVisitTimer;
@synthesize villainStartedPoppingForThisTask = _villainStartedPoppingForThisTask;

#pragma mark - Standard controller stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// TODO If you use Interface Builder to create your views and initialize the view controller, you must not override this method.
// If you want to perform any additional initialization of your views, do so in the viewDidLoad method.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activeTaskNum = 0;
    self.villainStartedPoppingForThisTask = NO;
    self.bgTimeWarningNotifiction = nil;
    
    self.maxTimeLabelUpdater = nil;
    self.minTimeLabelUpdater = nil;
    self.villainPoppingTimer = nil;
    self.cancelVillainVisitTimer = nil;
    self.villainVisitTimer = nil;
    
    self.whenTaskStarted = nil;
    self.whenTaskPaused = nil;
    self.whenTaskScheduledToFinish = nil;
    self.firstWarningTime = nil;
    self.secondWarningTime = nil;
    self.finalCountdownTime = nil;
    self.whenMinTimeFinished = nil;
    self.whenWentToBg = nil;
    
    self.isRoutineComplete = NO;
    
    //
    // Handle iPhone 5, etc.  Move elements to the right side as needed.
    // This beats creating a whole new storyboard / nib for the iPhone 5!
    //
    CGRect screenBounds = [[RTSAppHelper sharedInstance] windowBoundsForLandscape:YES
                                                                       forCocos2d:NO];
    
    // These need to come in x pixels from the right
    self.doneButton.center = CGPointMake(screenBounds.size.width - 35.0,
                                         self.doneButton.center.y);
    
    CGRect doneButtonFrame = self.doneButton.frame;
    self.minTimerLabel.frame = doneButtonFrame;
    
    CGFloat topOfScreenToTopOfDoneButton = screenBounds.size.height - doneButtonFrame.origin.y;
    CGFloat minTimerBackgroundWidth = screenBounds.size.width - doneButtonFrame.origin.x;
    CGFloat minTimerBackgroundHeight = topOfScreenToTopOfDoneButton - self.pageControl.frame.size.height;
    self.minTimerBackground.frame = CGRectMake(self.doneButton.frame.origin.x, self.doneButton.frame.origin.y, minTimerBackgroundWidth, minTimerBackgroundHeight);
    
    self.cancelButton.center = CGPointMake(screenBounds.size.width - 28.0,
                                         self.cancelButton.center.y);
    self.baloonIcon.center = CGPointMake(screenBounds.size.width - 16.0,
                                           self.baloonIcon.center.y);

    // These are centered
    self.activityIndicator.center = CGPointMake(screenBounds.size.width / 2.0,
                                                screenBounds.size.height / 2.0);
    /*
    self.taskImageView.center = CGPointMake(screenBounds.size.width / 2.0,
                                            self.taskImageView.center.y / 2.0);
    self.taskImageView.center = CGPointMake(self.taskImageView.center.x,
                                            self.taskImageView.center.y);
     */    
}

- (void)viewDidUnload
{
    [self setCancelButton:nil];
    [self setPageControl:nil];
    [self setDoneButton:nil];
    [self setTaskImageView:nil];
    [self setActivityIndicator:nil];
    [self setUserPhotoView:nil];
    [self setBaloonIcon:nil];
    [self setUserPhotoViewiPhone5:nil];
    [self setTimeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.animationLayer = nil;
    self.cocos2dView = nil;
    self.cocos2dScene = nil;
}

-(void) didReceiveMemoryWarning {
    
    [[CCDirector sharedDirector] purgeCachedData];
    // TODO Use [[KTCocos2dEngine sharedInstance] purge]; instead?
    
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    // Init the page control
    self.pageControl.numberOfPages = [self.routineEntity.tasks count] 
                                     + 1; // Plus one page for the reward page
    self.pageControl.currentPage = self.activeTaskNum;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    // Register for bg/fg notifications from the app delegate
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToBackground)
                                                 name:KTNotificationAppDidEnterBackground
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restoreToForeground)
                                                 name:KTNotificationAppWillEnterForeground
                                               object:nil];
    
    // Adjust the GUI for full-screen custom tasks if applicable
    if ( [self.routineEntity.theme isCustomTheme] ) {
        [self adjustViewForCustomRoutine];
    }
}

-(void) viewDidAppear:(BOOL)animated {

    // Init the cocos2d stuff ~after~ the view has appeared to avoid
    // a slightly annoying delay when you launch the routine.
    // Thanks to config in the storyboard, the activity indicator will
    //  be spinning over a black background when the view first appears.
    [self initCocos2dLayer];
    
    // Once the cocos2d stuff is ready, shut down the activity indicator..
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
    // Show the controls now.  This way the xcode-based controls
    // show up at the same time as the cocosd-based controls.
    self.cancelButton.hidden = NO;
    self.doneButton.hidden = NO;
    
    // And start showing the tasks
    [self presentNextTask];
}

-(void) viewDidDisappear:(BOOL)animated {
 
    if ( self.cocos2dScene ) {
        [self.cocos2dScene stopAllActions];
        [self.animationLayer removeAllChildrenWithCleanup:YES];
        [self.animationLayer removeFromParentAndCleanup:YES];
        [self.cocos2dScene cleanup];
    }
    
    if ( self.animationLayer ) {
        [self.animationLayer stopAllActions];
        [self.animationLayer removeAllChildrenWithCleanup:YES];
        [self.animationLayer removeFromParentAndCleanup:YES];
        [self.animationLayer cleanup];
    }
    
    [self.cocos2dView removeFromSuperview];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// New way (>= iOS 6)
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - Lifecycle handling

- (void) goToBackground {
    
    // TODO Manage overlap between this and actuallyStopRoutine
    
    // Stop any ongoing sounds
    [[KTSoundPlayer sharedInstance] stopAllSounds];
    
    [self cancelScheduledJobsWithLocalNotifications:NO];
    
    self.whenWentToBg = [NSDate date];
    
    [self.animationLayer goToBackground];
}

- (void) restoreToForeground {
    
    if ( ! self.whenTaskPaused ) {
        
        [self scheduleJobs];
        
        // Update cocos2d too
        NSTimeInterval secondsLeft = [self.whenTaskScheduledToFinish timeIntervalSinceNow];
        NSDate* now = [NSDate date];
        NSTimeInterval secondsInBg = [now timeIntervalSinceDate:self.whenWentToBg];
        
        [self.animationLayer restoreToForegroundWithTime:secondsLeft timeInBackground:secondsInBg];
    }
}

#pragma mark - Actions

- (IBAction)stopRoutineTapped:(id)sender {
    
    if (!self.isRoutineComplete) {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"label.routine.stop", nil)
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"action.routine.continue", nil)
                                               otherButtonTitles:NSLocalizedString(@"action.routine.stop", nil), nil];
        [alert show];
    }
    else {
        [self actuallyStopRoutine];
    }
}


- (IBAction)doneWithTask:(id)sender {       

    // Stop any ongoing sounds
    [[KTSoundPlayer sharedInstance] stopAllSounds];

    //Play the "done" sounds
    [[KTSoundPlayer sharedInstance] playTaskCompleteSound];

    // Don't need warnings any more (some might have gone already)
    [self cancelScheduledJobsWithLocalNotifications:YES];
    
    // Stop the picture animation; this is a good visual cue that the
    // task is done, and it helps save CPU cycles for the cocos2d 
    // balloon reward animations :-)
    [self stopAnimatingTaskImage];
    
    // Disable the done button until the next task is ready
    self.doneButton.enabled = NO;

    //[self.animationLayer wrapUpTaskNumber:self.activeTaskNum isLastTask:NO];
    [self.animationLayer startCollectingBalloons];
}

-(void) stopAnimatingTaskImage {
    
    [self.taskImageView stopAnimating];
    
    if ( [self.taskImageView.animationImages count] > 0 ) {
        UIImage* firstFrame = [self.taskImageView.animationImages objectAtIndex:0];
        self.taskImageView.image = firstFrame;
    }
}

- (IBAction)pauseRoutine:(id)sender {

    // Pause animations
    self.pauseOverlay.hidden = NO;
    [self stopAnimatingTaskImage];
    [self.animationLayer pauseAnimations];
    
    // Cancel all timed jobs -- we don't know the resume time yet, could be four hours. :-)
    [self cancelScheduledJobsWithLocalNotifications:YES];
    
    // Save a timestamp for later
    self.whenTaskPaused = [NSDate date];
}

- (IBAction)resumeRoutine:(id)sender {
    
    // Resume animations
    self.pauseOverlay.hidden = YES;
    [self.taskImageView startAnimating];
    [self.animationLayer resumeAnimations];
    
    // Adjust the times.  It's as if we started the routine x seconds later than we did,
    // where x is the pasue duration.
    [self calculateTiming];
    
    // Now recalculate the timed based on the pause time
    [self scheduleJobs];
}

#pragma mark - UIAletViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ( buttonIndex != alertView.cancelButtonIndex ) {
        [self actuallyStopRoutine];
    }
}


#pragma mark - KTRunRoutineCocos2dLayerDelegate

-(void) finishedWithResultRatio:(NSString*) resultRatio {
    self.timeLabel.hidden = NO;
    self.timeLabel.text = resultRatio;
}

-(BOOL) isCustomRoutine {
    return [self.routineEntity.theme isCustomTheme];
}

-(void) doneCollectingBalloons {
    [self incrementTaskNum];
    
    NSUInteger numTasks = self.routineEntity.tasks.count;
    
    // Do there regardless of whether it is the last, reward pageY
    //self.taskImageView.opaque = YES;
    //self.taskImageView.alpha = 1.0;
    [self.taskImageView startAnimating];
    
    if ( activeTaskNum < numTasks ) {
        
        // Okay, there is another task to go to...
        [self presentNextTask];
        
        //self.taskImageView.opaque = YES;
        //self.taskImageView.alpha = 1.0;
        [self.taskImageView startAnimating];
        
        // Re-enable the done button when the next task is ready
        self.doneButton.enabled = YES;
        //self.doneButton.opaque = YES;
        //self.doneButton.alpha = 1.0;
    }
    else if ( activeTaskNum >= numTasks ) {
        
        // We are out of tasks, people.
        // Rather than hide the done button, turn it into a visual
        // hint to pop the balloons.
        UIImage* touchImage = [UIImage imageNamed:@"touch"];
        [self.doneButton setImage:touchImage forState:UIControlStateNormal];
        self.doneButton.enabled = NO;
        self.isRoutineComplete = YES;
        [self presentReward];
    }
    else {
        // TODO - should never happen ;-)
    }
}

/*
-(void) donePresentingRewards {
// Anything to do?
}
*/

-(CGPoint) closeButtonCenter {
    return self.cancelButton.center;
}

-(void) exitRoutine {
    // TODO Is this used?
    [self stopRoutineTapped:nil];
}

/*
-(void)readyForNextTask {

    [self incrementTaskNum];
    
    NSUInteger numTasks = self.routineEntity.tasks.count;    
    
    // Do there regardless of whether it is the last, reward pageY
    //self.taskImageView.opaque = YES;
    //self.taskImageView.alpha = 1.0;
    [self.taskImageView startAnimating];
    
    if ( activeTaskNum < numTasks ) {    
        
        // Okay, there is another task to go to...        
        [self presentNextTask];    
        
        //self.taskImageView.opaque = YES;
        //self.taskImageView.alpha = 1.0;
        [self.taskImageView startAnimating];
        
        // Re-enable the done button when the next task is ready
        self.doneButton.enabled = YES;
        //self.doneButton.opaque = YES;
        //self.doneButton.alpha = 1.0;
    }
    else if ( activeTaskNum >= numTasks ) {
        
        // We are out of tasks, people.
        self.doneButton.hidden = YES;        
        [self presentReward];            
    }
    else {
        // TODO - should never happen ;-)
    }
    
}
*/

@end

@implementation KTRunRoutineTaskController (hidden)

-(void) incrementTaskNum {    
    self.activeTaskNum++;    
    self.pageControl.currentPage = self.activeTaskNum;
}

-(void) presentReward {
    
    self.minTimerLabel.hidden = YES;
    self.minTimerBackground.hidden = YES;
    
    //
    // First change to the last image for the reward
    //
    // TODO Avoid copying code from -presentNextTask below; 
    // refactor to reuse as practical.
    //    
    
    KTTheme* theme = routineEntity.theme;
    NSString* themeName = theme.nameKey;

    
    // Skip the special reward image on custom routines.
    // Just leave whatever the last image was.
    if ( ! [theme isCustomTheme] ) {
        
        self.taskImageView.image = nil;
        
        // Collect the set of images to animate
        NSMutableArray* animImages = [NSMutableArray array];
        
        BOOL moreFiles = YES;
        int fileIndex = 0;
        
        while ( moreFiles ) {
            // Note that the 0 on the end means "first frame".
            // To suport anmation, keep trying to get -1, -2, etc. and
            // add those to the image or image view view animation array.
            NSString* imageFileName = [NSString
                                       stringWithFormat:@"theme-%@-reward-%d",
                                       themeName, fileIndex++];
            
            UIImage* image = [UIImage imageNamed:imageFileName];
            
            if ( image ) {
                [animImages addObject:image];
            }
            else {
                moreFiles = NO;
            }
        }
        
        [UIView transitionWithView:self.view
                          duration:1.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.taskImageView.animationImages = animImages;
                            // How long to cycle through all the images.
                            // So 2.0 would mean a new frame every second if I have two frames.
                            // I like to use something slightly off of an evene second to avoid appearing
                            // to be synchronized with the seconds in the timer clock, which somehow
                            // gives it a cheaper efect.
                            // TODO calc from # frames TODO Get this from the database per theme + task ?
                            self.taskImageView.animationDuration = 1.75;
                            self.taskImageView.animationRepeatCount = 0; // Repeat indefinitely
                            [self.taskImageView startAnimating];    
                        } completion:NULL];
    }
    
    //
    // TODO Also, hide the timer, "done" button, and any other now-obsolete controls
    
    //
    // Then tell the cocos2d part to do its thing
    //
    [self.cocos2dView setUserInteractionEnabled:YES];
    //[self.animationLayer showRoutineFinalRewardScreen];
    [self.animationLayer startPresentingRewards];
}


-(void) presentNextTask {
    
    self.villainStartedPoppingForThisTask = NO;
    
    [self hideOrShowTimeLimitControls];
    
    // Go to the next view image
    // TODO Do this only once when the routine starts.  
    // The theme will not change in the middle of running!
    // BUT Is this really such a big deal???  Probably not.
    KTTheme* theme = routineEntity.theme;
    NSString* themeName = theme.nameKey;
    
    // The task num has already been incremented, so pull the "current" task
    // to get the next one.
    KTTask* task = [self currentTask];
    
    // Determine if this is a custom task (for later)
    BOOL isCustomTask = [task isCustomTask];
    
    // Collect the set of images to animate
    NSMutableArray* animImages = [NSMutableArray array];
    
    BOOL moreFiles = YES;
    int fileIndex = 0;
    
    // Find the file by name.  Initially assume <= iPhone 4 dimensions
    NSString* imageFileNameFormat = @"theme-%@-%@-%d";
    
    // But use a different image file for >= iPhone 5
    BOOL isFourInch = ([[RTSAppHelper sharedInstance] screenResolution] == kRTSScreenResolutioniPhone5);
    
    if ( isFourInch ) {
        imageFileNameFormat = @"theme-%@-%@-%d-4inch";
    }
    
    while ( moreFiles ) {
        // Note that the 0 on the end means "first frame".
        // To suport anmation, keep trying to get -1, -2, etc. and
        // add those to the image or image view view animation array.
        NSString* imageFileName = [NSString
                                   stringWithFormat:imageFileNameFormat, 
                                   themeName, task.type, fileIndex++];
        
        UIImage* image = [UIImage imageNamed:imageFileName];
        
        if ( image ) {
            [animImages addObject:image];
        }
        else {
            moreFiles = NO;
        }
    }
    
    // Adjust the view for the custom photo for iPhone 5 if needed as well
    UIImageView* viewForUserPicture = nil;
    if ( [self isCustomRoutine] ) {
        viewForUserPicture = self.userPhotoBlankSlate;
    }
    else {
        if ( isFourInch ) {
            viewForUserPicture = self.userPhotoViewiPhone5;
        }
        else {
            viewForUserPicture = self.userPhotoView;
        }
    }
    
    // Show or hide custom image, as applicable
    if ( isCustomTask ) {        
        UIImage* userImage = [task imageWithSize:RTSImageSizeScreen];
        viewForUserPicture.image = userImage;
        viewForUserPicture.hidden = NO;
    }
    else {
        viewForUserPicture.hidden = YES;
        viewForUserPicture.image = nil;
    }

    [UIView transitionWithView:self.view
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.taskImageView.animationImages = animImages;
                        self.taskImageView.animationDuration = 1.75; // How long to cycle through all the images TODO calc from # frames
                        self.taskImageView.animationRepeatCount = 0; // Repeat indefinitely
                        [self.taskImageView startAnimating];    
                    } completion:NULL];        
    
    // If custom task, show the user-select image too
    
    // Reset the villain balloon popping song and dance
    //int taskSeconds = [[[self currentTask] timeInSeconds] intValue];
    //[self.animationLayer startTaskNumber:self.activeTaskNum WithTime:taskSeconds];
    [self.animationLayer startTask:self.currentTask];
    
    [self calculateTiming];
    
    // Set up timed triggers for events
    [self scheduleJobs];
}

-(void) calculateTiming {

    if ( self.whenTaskPaused ) {
        // Figure out new timeing from the pause duration
        NSTimeInterval pauseDuration = [self.whenTaskPaused timeIntervalSinceNow] * -1.0;
        self.whenTaskStarted = [NSDate dateWithTimeInterval:pauseDuration sinceDate:self.whenTaskStarted];
        self.whenTaskPaused = nil;
    }
    else {
        // Just a straight task start
        self.whenTaskStarted = [NSDate date];
    }
    
    self.whenTaskScheduledToFinish = [NSDate dateWithTimeInterval:[self.currentTask.timeInSeconds floatValue]
                                                        sinceDate:self.whenTaskStarted];

    if ([self.currentTask hasTimeMin]) {
        self.whenMinTimeFinished = [NSDate dateWithTimeInterval:[self.currentTask.minTimeInSeconds
                                                                 floatValue] sinceDate:self.whenTaskStarted];
    }
    else {
        self.whenMinTimeFinished = nil;
    }
    
    // 1 minute warning time
    self.firstWarningTime = [NSDate dateWithTimeInterval:-60.0 sinceDate:self.whenTaskScheduledToFinish];
    
    // 30 second warning time
    self.secondWarningTime = [NSDate dateWithTimeInterval:-30.0 sinceDate:self.whenTaskScheduledToFinish];
    
    // Final countdown time
    NSTimeInterval countdownSoundDuration = [[KTSoundPlayer sharedInstance] countdownSoundDuration];
    self.finalCountdownTime = [NSDate dateWithTimeInterval:-countdownSoundDuration sinceDate:self.whenTaskScheduledToFinish];
}

-(void) cancelScheduledJobsWithLocalNotifications:(BOOL) inclLocalNots {
    
    [[KTSoundPlayer sharedInstance] cancelAllScheduledSounds];
    
    [self.maxTimeLabelUpdater invalidate];
    self.maxTimeLabelUpdater = nil;
    [self.minTimeLabelUpdater invalidate];
    self.minTimeLabelUpdater = nil;
    [self.villainPoppingTimer invalidate];
    self.villainPoppingTimer = nil;
    [self.cancelVillainVisitTimer invalidate];
    self.cancelVillainVisitTimer = nil;
    [self.villainVisitTimer invalidate];
    self.villainVisitTimer = nil;
    
    if ( inclLocalNots ) {
        [self.bgTimeWarningNotifiction cancel];
    }
}

/*
 * This method clears any scheduled jobs and kicks them off again.
 * This is useful when coming back from the background.
 * It helps avoid any jobs which would have executed before now.
 */
-(void) scheduleJobs {

    // Scheduled jobs will NOT be ignored if in the past, so we have to check the
    // scheuled time against now before scheduling.
    NSDate* now = [NSDate date];
    
    //
    // Villain corner buzzing
    //
    if ( ! self.villainStartedPoppingForThisTask ) {
        self.villainVisitTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0]
                                                            interval:15.0 // Repeat every x seconds
                                                              target:self
                                                            selector:@selector(kickOffVillainVisit:)
                                                            userInfo:nil
                                                             repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.villainVisitTimer forMode:NSDefaultRunLoopMode];
    }
    
    //
    // Timers that apply to maximum time limit
    //
    if ( [self.currentTask hasTimeLimit] ) {
        
        //
        // Warning sounds
        //
        if ( [self.firstWarningTime compare:now] == NSOrderedDescending ) {
            [[KTSoundPlayer sharedInstance] scheduleFirstWarningSoundAt:self.firstWarningTime];
        }
        
        if ( [self.secondWarningTime compare:now] == NSOrderedDescending ) {
            [[KTSoundPlayer sharedInstance] scheduleSecondWarningSoundAt:self.secondWarningTime];
        }
        
        if ( [self.finalCountdownTime compare:now] == NSOrderedDescending ) {
            [[KTSoundPlayer sharedInstance] scheduleCountdownSoundAt:self.finalCountdownTime];
        }

        //
        // Villian balloon popping
        //
        if ( ! self.villainStartedPoppingForThisTask ) {
            
            // Reset the villain timer
            [self.villainPoppingTimer invalidate];
            
            // whenTaskScheduledToFinish not being updated
            self.villainPoppingTimer = [[NSTimer alloc] initWithFireDate:[self.whenTaskScheduledToFinish dateByAddingTimeInterval:-6.0]
                                                                interval:0.0
                                                                  target:self
                                                                selector:@selector(kickOffVillainBalloonPopping:)
                                                                userInfo:nil
                                                                 repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.villainPoppingTimer forMode:NSDefaultRunLoopMode];
        }
        
        
        // Also cancel all buzzing 10 sconds before the end of the task's time, to avoid
        // interfering with the baloon popping, etc.
        self.cancelVillainVisitTimer = [[NSTimer alloc]
                                        initWithFireDate:[self.whenTaskScheduledToFinish dateByAddingTimeInterval:-10.0]
                                        interval:0.0
                                        target:self
                                        selector:@selector(cancelVillainVisits:)
                                        userInfo:nil
                                        repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.cancelVillainVisitTimer forMode:NSDefaultRunLoopMode];
        
        //
        // Keep the max timer up to date
        //
        self.maxTimeLabelUpdater = [[NSTimer alloc] initWithFireDate:now
                                                         interval:1.0
                                                           target:self
                                                         selector:@selector(updateMaxTimeLabel:)
                                                         userInfo:nil
                                                          repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.maxTimeLabelUpdater forMode:NSDefaultRunLoopMode];
    }
    else {
        self.villainPoppingTimer = nil;
        self.cancelVillainVisitTimer = nil;
        self.maxTimeLabelUpdater = nil;
    }
    
    //
    // Handle minimum time
    //
    if ( [self.currentTask hasTimeMin] ) {

        //
        // Keep the min timer up to date
        //
        self.minTimeLabelUpdater = [[NSTimer alloc] initWithFireDate:now
                                                         interval:1.0
                                                           target:self
                                                         selector:@selector(updateMinTimeLabel:)
                                                         userInfo:nil
                                                          repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.minTimeLabelUpdater forMode:NSDefaultRunLoopMode];
    }
    else {
        self.minTimeLabelUpdater = nil;
    }
    
    // Schedule a local notification for when the app is in the background.
    // This will only show if the app is in the ~background~, which is what we want.
    // Another nice feature?  If the time is in the past, it will be ignored.
    if ( self.bgTimeWarningNotifiction ) {
        [self.bgTimeWarningNotifiction cancel];
    }
    self.bgTimeWarningNotifiction = [[KTTaskNotifiication alloc] initWithTask:self.currentTask];
    [self.bgTimeWarningNotifiction scheduleForDate:self.secondWarningTime];
}

- (void)kickOffVillainVisit:(NSTimer*)theTimer {
    [self.animationLayer startVillainVisit];
}

- (void)cancelVillainVisits:(NSTimer*)theTimer {
    [self.villainVisitTimer invalidate];
}

- (void)kickOffVillainBalloonPopping:(NSTimer*)theTimer {
    [self.animationLayer startPoppingBalloons];
    [self.villainVisitTimer invalidate];
    self.villainStartedPoppingForThisTask = YES;
}

-(void) cancelVillainBalloonPopping {
    [[NSRunLoop mainRunLoop] cancelPerformSelector:@selector(kickOffVillainBalloonPopping:)
                                            target:self
                                          argument:nil];
}

- (void)disableDoneButton {
    self.minTimerLabel.hidden = NO;
    self.minTimerBackground.hidden = NO;
    self.doneButton.enabled = NO;
}

- (void)enableDoneButton {
    self.minTimerLabel.hidden = YES;
    self.minTimerBackground.hidden = YES;
    self.doneButton.enabled = YES;
}


- (void)updateMaxTimeLabel:(NSTimer*)theTimer {

    if ( self.whenTaskScheduledToFinish ) {
        
        int rawSecsLeft = (int) [self.whenTaskScheduledToFinish timeIntervalSinceNow];
        
        if ( rawSecsLeft > 0 ) {
            self.timeLabel.text = [NSString stringWithFormat:@"%02i:%02i", rawSecsLeft / 60, rawSecsLeft % 60];
        }
        else {
            self.timeLabel.text = @"00:00";
            [self.maxTimeLabelUpdater invalidate];
        }
    }
}

- (void)updateMinTimeLabel:(NSTimer*)theTimer {
    
    if ( self.whenMinTimeFinished ) {
        
        int rawSecsLeft = (int) [self.whenMinTimeFinished timeIntervalSinceNow];
        
        if ( rawSecsLeft > 0 ) {
            self.minTimerLabel.text = [NSString stringWithFormat:@"%02i:%02i", rawSecsLeft / 60, rawSecsLeft % 60];
        }
        else {
            [self enableDoneButton];
            [self.minTimeLabelUpdater invalidate];
        }
    }
    
}

-(void) hideOrShowTimeLimitControls {
    
    if ( [self.currentTask hasTimeLimit] ) {
        // We DO want to see the controls
        self.timeLabel.hidden = NO;
        [self.animationLayer showTimeLimitControls];
    }
    else {
        // We do NOT want to see the controls
        self.timeLabel.hidden = YES;
        [self.animationLayer hideTimeLimitControls];
    }

    // Show/hide the next button, as applicable
    if ([self.currentTask hasTimeMin]) {
        [self disableDoneButton];
    }
    else {
        self.whenMinTimeFinished = nil;
        [self enableDoneButton];
    }
}

-(void) adjustViewForCustomRoutine {
    
    self.taskImageView.hidden = YES;
    self.userPhotoView.hidden = YES;
    self.userPhotoViewiPhone5.hidden = YES;
    self.pageControl.alpha = 0.75;    
    self.userPhotoBlankSlate.hidden = NO;
}


// TODO Make this a property
// Reutrns nil if the task is not in range
-(KTTask*) currentTask {    
    
    KTTask* retval = nil;    
    NSUInteger numTasks = self.routineEntity.tasks.count;
    
    if ( activeTaskNum < numTasks ) {
        retval = (KTTask*) [self.routineEntity.tasks objectAtIndex:self.activeTaskNum];
    }
    
    return retval;
}

-(void) actuallyStopRoutine {
    
    // Stop any ongoing sounds
    [[KTSoundPlayer sharedInstance] stopAllSounds];
    
    // Don't need warnings any more (some might have gone already)
    [self cancelScheduledJobsWithLocalNotifications:YES];
    
    // Just make double sure that we don't have any notifications
    // show up after leaving the routine for any reason
    [KTTaskNotifiication cancelAll];
    
    // Go back to the routine launch UI
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[KTSoundPlayer sharedInstance] stopAllSounds];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) initCocos2dLayer {
    
    // Add the cocos2d view
    // This returns the same shared view every time
    self.cocos2dView = [[KTCocos2dEngine sharedInstance] view];

    if( ! [[CCDirector sharedDirector] enableRetinaDisplay:YES] ) {
        LOG_COCOS2D(@"Retina Display Not supported");
    }
    
    // Prevent the cocos2d layer from receiving any touch inputs at first.
    // We will save all interaction for the UIKit view below.
    // (This will be re-enabled on the final reward screen.)
    [self.cocos2dView setUserInteractionEnabled:NO];
    
    //[self.view insertSubview:self.cocos2dView atIndex:0];        
    [self.view insertSubview:self.cocos2dView aboveSubview:self.view];
    
    // We get a new scene every time
    self.cocos2dScene = [KTRoutineAnimationsLayer scene];
    [[CCDirector sharedDirector] pushScene:self.cocos2dScene];
    
    // This seems ugly but is copied right form cocos2d...
    // We get a new layer along with the new scene
	self.animationLayer = (KTRoutineAnimationsLayer*) [[self.cocos2dScene children] objectAtIndex:0];
    self.animationLayer.delegate = self;
    //[self.animationLayer prepareForRoutine:self.routineEntity];
    [self.animationLayer loadRoutine:self.routineEntity];
}

@end

