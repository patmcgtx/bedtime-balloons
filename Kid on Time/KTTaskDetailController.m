//
//  DetailViewController.m
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "KTTaskDetailController.h"
#import "DataSource.h"
#import "ADVTheme.h"
#import "KTRoutinePlus.h"
#import "KTTaskPlus.h"
#import "KTTaskBasePlus.h"
#import "KTDataAccess.h"
#import "KTConstants.h"
#import "RTSLog.h"
#import "KTTaskImageEditorController.h"
#import "KTThemePlus.h"

@interface KTTaskDetailController ()

@property (nonatomic, strong) KTRoutine* routineEntity;
@property (nonatomic, strong) NSMutableDictionary* tasksToImages;

@property (nonatomic,strong) UIBarButtonItem* editButton;
@property (nonatomic,strong) UIBarButtonItem* doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;

-(void) saveCurrentTaskToDb;
-(void) refreshViewForCurrentTask;

@end

@implementation KTTaskDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // The task should have been supplied in the segueue
    NSAssert(self.taskEntity, @"task detail controller missing task entity");
    
    // Get routine can be derived from the task
    self.routineEntity = self.taskEntity.routine;
    NSAssert(self.taskEntity, @"task detail controller failed to derive routine entity");

    self.tasksToImages = [NSMutableDictionary dictionaryWithCapacity:[self.routineEntity.tasks count]];
    
    self.pageControl.numberOfPages = [self.routineEntity.tasks count];
    self.pageControl.currentPage = [self.taskEntity indexWithinRoutine];
    
    self.taskNameTextField.font = [UIFont fontWithName:[ADVTheme boldFont] size:17.0f];
    
    self.scrollView.delegate = self;
    self.taskNameTextField.delegate = self;

    // Set up the time range control
    [self.timeRangerSlider setup];
    self.timeRangerSlider.delegate = self;
    
    // Populate the data from the db
    [self refreshViewForCurrentTask];
    
    // Put away the keyboard when not being used any more
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self.taskNameTextField
                                                 action:@selector(resignFirstResponder)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    //
    // Set up the scroll view with all the tasks.
    // This scroll view is all based on sample code, etc.
    // I don't 100% understand all of it. :-L
    //
    
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    // Make the image preview the same resolution ratio as the screen
    // so it matches what we will see when we run the app.
    // This looks tricky, but it's just basic algrbra.
    // We have the screen width/height, and the preview width is constant,
    // We just need to determine the preview height.
    // Since the screen is rotated to landscape mode, we swap screen width and height.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    CGFloat previewWidth = self.scrollView.frame.size.width;
    CGFloat previewHeightOrig = self.scrollView.frame.size.height;
    CGFloat previewHeight = previewWidth * screenSize.width / screenSize.height; // / [[UIScreen mainScreen] scale];
    CGFloat heightDiff = previewHeightOrig - previewHeight;
    
    CGFloat paddingHoriz = 5.0;
    CGFloat paddingVert = 10.0;
    int i = 0;
    
    for (KTTask* task in self.routineEntity.tasks) {
        
        CGRect previewFrame = CGRectMake(((self.scrollView.frame.size.width) * i++) + paddingHoriz,
                                         paddingVert + heightDiff/2,
                                         (self.scrollView.frame.size.width) - (paddingHoriz * 2),
                                         previewHeight - (paddingVert * 2));

        UIImageView* preview = [[UIImageView alloc] initWithFrame:previewFrame];
        preview.image = [task imageWithSize:RTSImageSizeScreen];
        preview.contentMode = UIViewContentModeScaleAspectFill;
        preview.clipsToBounds = YES;
        preview.userInteractionEnabled = YES;
        
        [self.tasksToImages setObject:preview forKey:task.shortId];
        
        if ( [task isCustomTask] ) {
            
            UIButton* cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            cropButton.backgroundColor = [UIColor darkGrayColor];
            cropButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
            cropButton.alpha = 0.75;
            cropButton.contentMode = UIViewContentModeCenter;
            [cropButton setImage:[UIImage imageNamed:@"crop"] forState:UIControlStateNormal];
            [cropButton setImageEdgeInsets:UIEdgeInsetsZero];
            cropButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            cropButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            // So I ended up adding the bigInvisibleButton below, since this little crop button
            // was kind of hard to tap.  The big button just lets you tap anywhere on the image.
            // So this button is disabled for now.  It could basically be in image view, but
            // I am leaving it as a button in case I want to tweak it later.
            //cropButton.enabled = YES;
            //[cropButton addTarget:self action:@selector(openTaskImageEditor) forControlEvents:UIControlEventTouchUpInside];
            
            [preview addSubview:cropButton];

            UIButton* bigInvisibleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            bigInvisibleButton.frame = CGRectMake(0.0, 0.0, preview.bounds.size.width, preview.bounds.size.height);
            bigInvisibleButton.backgroundColor = [UIColor clearColor];
            [bigInvisibleButton addTarget:self action:@selector(openTaskImageEditor) forControlEvents:UIControlEventTouchUpInside];
            
            [preview addSubview:bigInvisibleButton];
        }
        
        [self.scrollView addSubview:preview];
    }
    
    // Watch for changes to task images
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTaskImage:)
                                                 name:KTNotificationTaskImageDidChange
                                               object:nil];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.routineEntity.tasks count], previewHeight);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * [self.taskEntity indexWithinRoutine], 0);
    [self refreshPageNum];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = self.routineEntity.name;
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.topItem.title = nil;
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self saveCurrentTaskToDb];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications

-(void) refreshTaskImage:(NSNotification*) notification {
    
    if ( [notification.object isKindOfClass:[KTTask class]] ) {
        
        KTTask* sourceTask = (KTTask*) notification.object;
        UIImageView* imageToUpdate = [self.tasksToImages objectForKey:sourceTask.shortId];
        
        if ( imageToUpdate ) {
            // Have to do this on the main thread or it does not update for several seconds, if not longer.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView transitionWithView:imageToUpdate
                                  duration:0.5f
                                   options:UIViewAnimationOptionTransitionCurlDown
                                animations:^{
                                    imageToUpdate.image = [sourceTask imageWithSize:RTSImageSizeScreen];
                                } completion:nil];
            });
        }
    }
}

-(void) refreshTaskPlaceholder:(NSNotification*) notification {
    // TODO: KIDSCHED-519
}

#pragma mark - Segues

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"taskToImageEditor"] )
    {
        KTTaskImageEditorController* destController = (KTTaskImageEditorController*) segue.destinationViewController;
        destController.delegate = self;
    }
}

#pragma mark - UIScrollView delegate

// This is called when we scroll to the prev/next task
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    // Save the old task we just left
    [self saveCurrentTaskToDb];
    
    // Refresh the paging to the new task
    NSUInteger newPageNum = [self refreshPageNum];
    
    // The task preview image was loaded on -viewDidLoad,
    // but refresh the other data now.
    self.taskEntity = [self.routineEntity.tasks objectAtIndex:newPageNum];
    [self refreshViewForCurrentTask];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - KTTaskTimeDoubleSliderDelegate

-(void) taskTimerMinDidChangeTo:(NSUInteger) minTimeInMins {
    
    //LOG_TMP_DEBUG(@"delegate min => %i", minTimeInMins);
    NSString* labelString = nil;

    if ( minTimeInMins > 0 ) {
        labelString = [NSString stringWithFormat:NSLocalizedString(@"label.min.time", nil), minTimeInMins,
                  (minTimeInMins > 1 ? NSLocalizedString(@"label.minutes", nil) : NSLocalizedString(@"label.minute", nil))];
    }
    else {
        labelString = NSLocalizedString(@"label.min.none", nil);
    }
    
    self.taskMinTimeLabel.text = labelString;
}

-(void) taskTimerMaxDidChangeTo:(NSUInteger) maxTimeInMins {
    
    //LOG_TMP_DEBUG(@"delegate min => %i", maxTimeInMins);
    NSString* labelString = nil;
    
    if ( maxTimeInMins < kKTMaxTaskTimeInMins ) {
        labelString = [NSString stringWithFormat:NSLocalizedString(@"label.max.time", nil), maxTimeInMins,
                  (maxTimeInMins > 1 ? NSLocalizedString(@"label.minutes", nil) : NSLocalizedString(@"label.minute", nil))];
    }
    else {
        labelString = NSLocalizedString(@"label.max.none", nil);
    }
    
    self.taskMaxTimeLabel.text = labelString;
}

#pragma mark - KTImageEditorDelegate

-(UIImage*) imageForImageEditor {
    return [self.taskEntity imageWithSize:RTSImageSizeOriginal];
}

-(void) imageEditorDidFinishWithImage:(UIImage*) editedImage {
    [self.taskEntity saveCustomImage:editedImage incudingOriginal:NO];
}

-(BOOL) imageEditorIsForBlankSlateRoutine {
    return [self.routineEntity.theme isCustomTheme];
}

#pragma mark - Internal helpers

-(void) openTaskImageEditor {
    [self performSegueWithIdentifier:@"taskToImageEditor" sender:self];
}

-(void) saveCurrentTaskToDb {
    
    NSAssert(self.taskEntity, @"task detail controller - commit - no task entity selected");
    
    NSUInteger sliderMinTimeInSecs = self.timeRangerSlider.selectedMinTimeInSeconds;
    NSUInteger sliderMaxTimeInSecs = self.timeRangerSlider.selectedMaxTimeInSeconds;
    
    BOOL didUpdate = [self.taskEntity mayebUpdateName:self.taskNameTextField.text
                                        minTimeInSecs:sliderMinTimeInSecs
                                        maxTimeInSecs:sliderMaxTimeInSecs
                                               commit:YES];
    
    if ( didUpdate ) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationTaskNameDidChange
                                                            object:self
                                                          userInfo:[NSDictionary
                                                                    dictionaryWithObject:self.taskEntity
                                                                    forKey:KTKeyTaskEntity]];
    }
}

-(NSUInteger) refreshPageNum {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger currPage = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = currPage;
    return currPage;
}


// Refreshes the task view from the database
-(void) refreshViewForCurrentTask {
    
    NSAssert(self.taskEntity, @"task detail controller - refresh - no task entity selected");
    
    self.taskNameTextField.text = self.taskEntity.name;    
    self.timeRangerSlider.selectedMinTimeInMinutes = [self.taskEntity minTimeInMinutes];
    self.timeRangerSlider.selectedMaxTimeInMinutes = [self.taskEntity maxTimeInMinutes];
}

@end
