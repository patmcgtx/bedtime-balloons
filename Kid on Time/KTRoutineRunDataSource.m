//
//  KTRoutineRunDataSource.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTRoutineRunDataSource.h"
#import "RTSLog.h"

@implementation KTRoutineRunDataSource

#pragma mark - UIPageViewControllerDataSource

// In terms of navigation direction. For example, for 'UIPageViewControllerNavigationOrientationHorizontal', view controllers coming 'before' would be to the left of the argument view controller, those coming 'after' would be to the right.
// Return 'nil' to indicate that no more progress can be made in the given direction.
// For gesture-initiated transitions, the page view controller obtains view controllers via these methods, so use of setViewControllers:direction:animated:completion: is not required.

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    LOG_TMP_DEBUG(@"pageViewController viewControllerBeforeViewController");
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    LOG_TMP_DEBUG(@"pageViewController viewControllerAfterViewController");
    return nil;
}

@end
