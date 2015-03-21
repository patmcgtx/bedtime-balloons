//
//  KTParentalGateController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/20/14.
//
//

#import "KTParentalGateController.h"
#import "KTSwipeGesture.h"

/*
 * Per KIDSCHED-462, I no longer need this class.  And I was really starting to like it!
 * How to re-integrate this class into a view controller if needed later...
 
 @property (strong, nonatomic) KTParentalGateController* parentalGate;

 ...
 
 - (void)viewDidLoad {
 
 self.parentalGate = (KTParentalGateController*) [self.storyboard instantiateViewControllerWithIdentifier:@"KTParentalGateController"];
 self.parentalGate.delegate = self;
 
 ...
 
 -(void) finishBlankSlateRoutine {
 
self.parentalGate.purpose = NSLocalizedString(@"parentalgate.purpose.photos", nil);
 [self presentViewController:self.parentalGate animated:YES completion:nil];

 ...
 
 #pragma mark - KTParentalGateDelegate
 
 -(void) parentalCheckPassed {
 if ( self.parentalGate ) {
 [self.parentalGate dismissViewControllerAnimated:NO completion:^{
 // We'll hear back on the KTCreateRoutineDelegate methods when this completes
 [self presentViewController:self.multiIimagePicker animated:NO completion:nil];
 }];
 }
 }
 
 -(void) parentalCheckFailed {
 if ( self.parentalGate ) {
 [self.parentalGate dismissViewControllerAnimated:YES completion:nil];
 }
 }
 
 */

@interface KTParentalGateController ()

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;
@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (weak, nonatomic) IBOutlet UIView *instructionsFrameView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *lockIcon;

- (IBAction)didSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)dismissButtonPressed:(id)sender;

@end

@implementation KTParentalGateController

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
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.lockIcon.image = [UIImage imageNamed:@"locked"];
    self.titleLabel.text = NSLocalizedString(@"parentalgate.title", nil);
    self.purposeLabel.text = self.purpose;
    self.instructionsTextView.selectable = NO;
    
    KTSwipeGesture* swipe = [KTSwipeGesture randomGesture];
    
    self.swipeGestureRecognizer.numberOfTouchesRequired = swipe.numFingers;
    self.swipeGestureRecognizer.direction = swipe.direction;
    
    self.instructionsTextView.text = [swipe localizedInstructions];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)didSwipe:(UISwipeGestureRecognizer *)sender {

    [UIView transitionWithView:self.lockIcon
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.lockIcon.image = [UIImage imageNamed:@"unlocked"];
                    } completion:nil];
    
    [self performSelector:@selector(notifyDelegateOfSuccess) withObject:nil afterDelay:1.0];
}

- (IBAction)dismissButtonPressed:(id)sender {
    [self.delegate parentalCheckFailed];
}

#pragma mark - Internal helpers

-(void) notifyDelegateOfSuccess {
    [self.delegate parentalCheckPassed];
}


@end
