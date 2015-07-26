//
//  KTRoutineTaskPreviewCell.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 1/19/14.
//
//

#import "KTRoutineTaskPreviewCell.h"
#import "KTConstants.h"
#import "KTTaskPlus.h"
#import "RTSImageSize.h"

@interface KTRoutineTaskPreviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *taskStatusIndicator;

@end

@implementation KTRoutineTaskPreviewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    self.taskImageView.image = nil;
//    [self showLoadingImage];
//    [self hideProcessingImage];
//    [self showImageDownloadInProgress];
}

-(void) updateForTask:(KTTask *)taskEntity {
    
    UIImage* taskImage = [taskEntity imageWithSize:RTSImageSizeSmall];
    
    if ( taskEntity.imageState == KTTaskImageStateGood ) {
        self.taskImageView.image = taskImage;
        [self hideProcessingImage];
    }
    else if ( taskEntity.imageState == KTTaskImageStateDowloadingImage ) {
        [self showImageDownloadInProgress];
    }
    else if ( taskEntity.imageState == KTTaskImageStateDownloadFailed ) {
        [self showImageDownloadFailed];
    }

    self.taskEntity = taskEntity;
    
    // When my task says its image changed, then refresh my image
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTaskImage:)
                                                 name:KTNotificationTaskImageDidChange
                                               object:self.taskEntity];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(refreshTaskPlaceholder:)
//                                                 name:KTNotificationTaskPlaceholderImageDidChange
//                                               object:self.taskEntity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageDownloadFailed:)
                                                 name:KTNotificationTaskImageDownloadFailed
                                               object:self.taskEntity];
}

#pragma mark - Notifications

-(void) refreshTaskImage:(NSNotification*) notification {
    
    // Have to do this on the main thread or it does not update
    // for several seconds, if not longer.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.taskImageView.image = [self.taskEntity imageWithSize:RTSImageSizeSmall];
        [self hideProcessingImage];
    });
}

-(void) imageDownloadFailed:(NSNotification*) notification {
    
    // Have to do this on the main thread or it does not update
    // for several seconds, if not longer.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showImageDownloadFailed];
//        self.taskImageView.image = [UIImage imageNamed:@"cloud-storm"];
//        [self hideLoadingImage];
    });
}

//-(void) refreshTaskPlaceholder:(NSNotification*) notification {
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.taskImageView.image = [self.taskEntity placeholderImage];
//        [self hideLoadingImage];
//    });
//}

#pragma mark - Properties

-(void)setIsWaitingForDownload:(BOOL)isWaitingForDownload {
    
}


#pragma mark - Internal helpers

-(void) hideProcessingImage {
    self.taskImageView.hidden = NO;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.taskStatusIndicator.hidden = YES;
}

-(void) showProcessingImage {
    self.taskImageView.hidden = YES;
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
}

-(void) showImageDownloadInProgress {
    self.taskImageView.hidden = YES;
    self.taskImageView.image = nil;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.taskStatusIndicator.hidden = NO;
    self.taskStatusIndicator.image = [UIImage imageNamed:@"cloud-download"];
}

-(void) showImageDownloadFailed {
    self.taskImageView.hidden = YES;
    self.taskImageView.image = nil;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.taskStatusIndicator.hidden = NO;
    self.taskStatusIndicator.image = [UIImage imageNamed:@"cloud-storm"];
}


@end
