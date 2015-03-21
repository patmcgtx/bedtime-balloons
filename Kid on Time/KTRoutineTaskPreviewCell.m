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
    [self showLoadingImage];
}

-(void) updateForTask:(KTTask *)taskEntity {
    
    UIImage* taskImage = [taskEntity imageWithSize:RTSImageSizeSmall];
    
    if ( taskImage ) {
        self.taskImageView.image = [taskEntity imageWithSize:RTSImageSizeSmall];
        [self hideLoadingImage];
    }
    else {
        [self showLoadingImage];
    }

    self.taskEntity = taskEntity;
    
    // When my task says its image changed, then refresh my image
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTaskImage:)
                                                 name:KTNotificationTaskImageDidChange
                                               object:self.taskEntity];
}

#pragma mark - Notifications

-(void) refreshTaskImage:(NSNotification*) notification {
    
    // Have to do this on the main thread or it does not update
    // for several seconds, if not longer.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.taskImageView.image = [self.taskEntity imageWithSize:RTSImageSizeSmall];
        [self hideLoadingImage];
    });
}

#pragma mark - Internal helpers

-(void) hideLoadingImage {
    self.taskImageView.hidden = NO;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

-(void) showLoadingImage {
    self.taskImageView.hidden = YES;
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
}

@end
