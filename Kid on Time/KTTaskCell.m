//
//  KTTaskCell.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/9/14.
//
//

#import "KTTaskCell.h"
#import "KTConstants.h"
#import "KTTaskBasePlus.h"
#import "KTDataAccess.h"
#import "KTRoutinePlus.h"

@interface KTTaskCell ()

// Controls
@property (weak, nonatomic) IBOutlet UIImageView *taskPreviewImage;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *taskStatusIndicator;

@property (strong, nonatomic) UILongPressGestureRecognizer* gestureRecognizer;

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender;

@end

@implementation KTTaskCell

@synthesize isEditing = _isEditing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    self.taskEntity = nil;
    self.toolbar = nil;
    self.taskPreviewImage.image = nil;
    self.taskPreviewImage.hidden = YES;
    self.taskNameLabel.text = @"";
    self.taskTimeLabel.text = @"";
    self.deleteButton.hidden = YES;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    
//    [self showImageDownloadInProgress];
}

-(void) prepareForTask:(KTTask*) updatedTask isEditing:(BOOL) isEditing isNew:(BOOL) isNew {

    [self updateLabelForCurrentPosition];

    NSString* timeText = [updatedTask localizedShortTimeDescription];
    if ( timeText ) {
        self.taskTimeLabel.text = timeText;
        self.taskTimeLabel.hidden = NO;
    }
    else {
        self.taskTimeLabel.hidden = YES;
    }

    
    UIImage* taskImage = [updatedTask imageWithSize:RTSImageSizeMedium];
    
    if ( taskImage && updatedTask.imageState == KTTaskImageStateGood ) {
        self.taskPreviewImage.image = taskImage;
        self.taskPreviewImage.hidden = NO;
        [self hideProcessingImage];
    }
    else if (updatedTask.imageState == KTTaskImageStateDowloadingImage) {
        if (updatedTask.isCustomTask) {
            [self showImageDownloadInProgress];
        }
    }
    else if (updatedTask.imageState == KTTaskImageStateDownloadFailed) {
        if (updatedTask.isCustomTask) {
            [self showImageDownloadFailed];
        }
    }
    
    self.isEditing = isEditing;
    
    if ( ! self.gestureRecognizer ) {
        // This allows us to hide the delete button while moving the task cell
        self.gestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(handleLongPressGesture:)];
        self.gestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.gestureRecognizer];
    }
    
    // When my task says its image changed, then refresh my image
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTaskImage:)
                                                 name:KTNotificationTaskImageDidChange
                                               object:self.taskEntity];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(imageDownloadStarted:)
//                                                 name:KTNotificationTaskImageDownloadStarted
//                                               object:self.taskEntity];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageDownloadFailed:)
                                                 name:KTNotificationTaskImageDownloadFailed
                                               object:self.taskEntity];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(refreshTaskPlaceholder:)
//                                                 name:KTNotificationTaskPlaceholderImageDidChange
//                                               object:self.taskEntity];
}

-(void) updateLabelForCurrentPosition {
    unsigned long currentPos = [self.taskEntity indexWithinRoutine] + 1;
    self.taskNameLabel.text = [NSString stringWithFormat:@" %lu. %@",
                               currentPos,
                               self.taskEntity.name];
}

#pragma mark - Notifications

-(void) refreshTaskImage:(NSNotification*) notification {
    
    // Have to do this on the main thread or it does not update
    // for several seconds, if not longer.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.taskPreviewImage.image = [self.taskEntity imageWithSize:RTSImageSizeMedium];
        self.taskPreviewImage.hidden = NO;
        [self hideProcessingImage];
        self.taskStatusIndicator.image = nil;
        self.taskStatusIndicator.hidden = YES;
    });
}

-(void) imageDownloadFailed:(NSNotification*) notification {
    
    // Have to do this on the main thread or it does not update
    // for several seconds, if not longer.
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self hideProcessingImage];
//        self.taskStatusIndicator.hidden = NO;
        [self showImageDownloadFailed];
//        self.taskPreviewImage.image = [UIImage imageNamed:@"cloud-storm"];
//        [self hideLoadingImage];
    });
}


-(void) imageDownloadStarted:(NSNotification*) notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showImageDownloadInProgress];
    });
}


//-(void) refreshTaskPlaceholder:(NSNotification*) notification {
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.taskPreviewImage.image = [self.taskEntity placeholderImage];
//        [self hideLoadingImage];
//    });
//}

#pragma mark - Actions

- (IBAction)deleteTask:(id)sender {

    NSString* title = nil;
    if ( self.taskEntity.name && [self.taskEntity.name length] > 0 ) {
        title = [NSString stringWithFormat:NSLocalizedString(@"label.delete.question", nil), self.taskEntity.name];
    }
    
    // Confirm
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"action.cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"action.delete", nil)
                                                    otherButtonTitles:nil];
    [actionSheet showFromToolbar:self.toolbar];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    // Hide the delete button while moving/dragging to avoid unseemly image cropping
    // TODO Is this working consistently?
    //self.deleteButton.hidden = YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == actionSheet.destructiveButtonIndex ) {
        
        NSUInteger deletedTaskIndex = [self.taskEntity indexWithinRoutine];
        
        KTRoutine* parentRoutine = self.taskEntity.routine;
        [parentRoutine deleteTask:self.taskEntity commit:YES];
        
        // Let other layers know to delete the task
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationDidDeleteTask
                                                            object:self
                                                          userInfo:[NSDictionary
                                                                    dictionaryWithObject:[NSNumber numberWithUnsignedInteger:deletedTaskIndex]
                                                                    forKey:KTKeyDeletedObjectIndex]];
        
        // Let other layers know about the update
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationRoutineTasksDidChange
                                                            object:self
                                                          userInfo:[NSDictionary
                                                                    dictionaryWithObject:parentRoutine
                                                                    forKey:KTKeyRoutineEntity]];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // Allow this object to handle the long press while also allowing the DraggableCollectionView stuff to work
    return YES;
}

#pragma mark - KTEditable

-(void) setIsEditing:(BOOL)isEditing {
    
    _isEditing = isEditing;
    
    if ( isEditing ) {
        self.deleteButton.alpha = 0.0;
        self.deleteButton.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        self.deleteButton.alpha = 1.0;
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.deleteButton.hidden = YES;
        }];
    }
}


#pragma mark - Internal helpers

-(void) hideProcessingImage {
    self.taskPreviewImage.hidden = NO;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

//-(void) showProcessingImage {
//    self.taskPreviewImage.hidden = YES;
//    self.taskPreviewImage.image = nil;
//    [self.activityIndicator startAnimating];
//    self.activityIndicator.hidden = NO;
//}

-(void) showImageDownloadInProgress {
    self.taskPreviewImage.hidden = YES;
    self.taskPreviewImage.image = nil;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.taskStatusIndicator.image = [UIImage imageNamed:@"cloud-download"];
    self.taskStatusIndicator.hidden = NO;
}

-(void) showImageDownloadFailed {
    self.taskPreviewImage.hidden = YES;
    self.taskPreviewImage.image = nil;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.taskStatusIndicator.image = [UIImage imageNamed:@"cloud-storm"];
    self.taskStatusIndicator.hidden = NO;
}

@end
