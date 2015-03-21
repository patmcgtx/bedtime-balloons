//
//  KTRoutineRunRootViewController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTRoutineRunRootController.h"
#import "KTRoutineRunDataSource.h"
#import "KTRoutineRunTaskPageController.h"
#import "RTSLog.h"

@interface KTRoutineRunRootController ()
@property (readonly, strong, nonatomic) KTRoutineRunDataSource* dataSource;
@end

@implementation KTRoutineRunRootController

@synthesize pageViewController = _pageViewController;
@synthesize dataSource = _dataSource;


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
	// Do any additional setup after loading the view.

    self.pageViewController = [[UIPageViewController alloc] 
                               initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                               navigationOrientation:UIPageViewControllerNavigationOrientationVertical
                               options:nil];
    self.pageViewController.delegate = self;
    
    KTRoutineRunTaskPageController *startingViewController = [self.dataSource
                                                              viewControllerAtIndex:0
                                                              storyboard:self.storyboard];    
    
    NSArray *viewControllers = [NSArray arrayWithObject:startingViewController];
    [self.pageViewController setViewControllers:viewControllers 
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO 
                                     completion:NULL];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Properties

- (KTRoutineRunDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[KTRoutineRunDataSource alloc] init];
    }
    return _dataSource;
}


#pragma mark - UIPageViewControllerDelegate

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController 
        didFinishAnimating:(BOOL)finished 
   previousViewControllers:(NSArray *)previousViewControllers 
       transitionCompleted:(BOOL)completed
{
    LOG_TMP_DEBUG(@"pageViewController didFinishAnimating");
}


@end
