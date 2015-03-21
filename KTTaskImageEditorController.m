//
//  KTTaskImageEditorController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/5/14.
//
//

#import "KTTaskImageEditorController.h"
#import <QuartzCore/QuartzCore.h>
#import "KTConstants.h"

@interface KTTaskImageEditorController ()

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *viewToCapture;
@property (weak, nonatomic) IBOutlet UIImageView *balloonPreview;
@property (weak, nonatomic) IBOutlet UIImageView *timerPreview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation KTTaskImageEditorController

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
    
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = kKTUserImageMinZoomScale;
    self.scrollView.maximumZoomScale = kKTUserImageMaxZoomScale;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.imageView.image = [self.delegate imageForImageEditor];
    self.balloonPreview.hidden = ![self.delegate imageEditorIsForBlankSlateRoutine];
    self.timerPreview.hidden = ![self.delegate imageEditorIsForBlankSlateRoutine];
    
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

-(void) viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    // Have to implement this to enable zooming
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    
    // Capture the preview as a "screenshot"
    CGSize viewSize = self.viewToCapture.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, YES, 0.0);
    [self.viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Do this in the background since it can take a little time
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self.delegate imageEditorDidFinishWithImage:image];
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
