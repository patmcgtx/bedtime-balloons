//
//  KTAppDelegate.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTAppDelegate.h"
#import "KTDatabasePopulator.h"
#import "KTDataAccess.h"
#import "KTSoundPlayer.h"
#import "RTSAppHelper.h"
#import "KTConstants.h"
#import "ADVTheme.h"
#import "KTErrorReporter.h"

@implementation KTAppDelegate

@synthesize window = _window;

NSMutableArray *routines;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* Disabled JMC - See KIDSCHED-462
    [[JMC sharedInstance]
     configureJiraConnect:@"https://roundtripsw.atlassian.net/"
     projectKey:@"BBSUPPORT"
     apiKey:@"09b16eef-4595-4ab3-be96-41fcaae24d4c"];
     */

    // Set up the error reporter
    [[KTErrorReporter sharedReporter] setRootViewController:self.window.rootViewController];
    
    [KTSoundPlayer sharedInstance]; // Load/init sounds and audio session
    
    RTSAppHelper* appHelper = [RTSAppHelper sharedInstance];
    
    // Set up the data access - have to set the shared store URL from here on startup
    [[KTDataAccess sharedInstance] setStoreURL:[NSURL 
                                                fileURLWithPathComponents:
                                                [NSArray arrayWithObjects:
                                                 [[appHelper applicationDocumentsDirectory] path], @"KidOnTime.sqlite", nil]]];
    
    // Find the various controllers.  Start with the main/top contoller, which is the tab bar.
    /*
    UITabBarController* tabBarController = (UITabBarController*) self.window.rootViewController;
    
    // The controller for the first tab is the routines nav controller
    UINavigationController* routinesNavController = [[tabBarController viewControllers] objectAtIndex:0];
    
    // The top/firstfirst controller in the routines nav is the routines controller    
    KTRoutinesViewController* routinesViewController = (KTRoutinesViewController*) [routinesNavController topViewController];
    //KTRoutinesViewController* routinesViewController = [[routinesNavController viewControllers] objectAtIndex:0];
     */

    [ADVTheme customizeTheme];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
        [ADVTheme customizeTabBar:tabController.tabBar];
    }

    // Initialize the Foody template
    /*
    [self customizeGlobalTheme];
    [self iPhoneInit];
     */
    
    // Populate the database if needed
    KTDatabasePopulator* populator = [[KTDatabasePopulator alloc] init];
    [populator populateDbIfEmpty];
    
    return YES;
}							

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
 
    // Notify anyone who is interested, namely the cocosd2d layer, if it's running.
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationAppDidEnterBackground
                                                        object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */

    // Notify anyone who is interested, namely the cocosd2d layer, if it's running.
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationAppWillEnterForeground
                                                        object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

// Below is fromthe Foody template sample app
#pragma mark - Foody custom template

/*
- (void)customizeGlobalTheme {
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    UIImage *navBarImage = [UIImage imageNamed:@"navbar-7.png"];
    if([Utils isVersion6AndBelow]){
        navBarImage = [UIImage imageNamed:@"navbar.png"];
    }
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    if([Utils isVersion6AndBelow]){
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor whiteColor], UITextAttributeTextColor,
          [UIFont boldSystemFontOfSize:18.0f], UITextAttributeFont,
          [UIColor darkGrayColor], UITextAttributeTextShadowColor,
          [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)], UITextAttributeTextShadowOffset, nil]];
        
        UIImage *barButton = [[UIImage imageNamed:@"navbar-icon.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        
        [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        
        UIImage *backButton = [[UIImage imageNamed:@"back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-item.png"]];
    }
    else{
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor whiteColor], NSForegroundColorAttributeName,
          [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName,
          [UIColor darkGrayColor], UITextAttributeTextShadowColor, // NSShadowAttributeName
          [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)], UITextAttributeTextShadowOffset, nil]]; // NSShadowAttributeName
        
        //UIImage* barButtonImage = [Utils createSolidColorImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.1] andSize:CGSizeMake(10, 10)];        
        // The lines below give a sublte whitish background for the edit buttons, etc.
        //[[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        //[[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        //[[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor], UITextAttributeTextColor,
                                                              [UIFont boldSystemFontOfSize:16.0f], UITextAttributeFont, [UIColor darkGrayColor], UITextAttributeTextShadowColor,  [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)], UITextAttributeTextShadowOffset,
                                                              nil] forState:UIControlStateNormal];
        
        
    }
    
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    UIImage *minImage = [[UIImage imageNamed:@"slider-track-fill.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
    UIImage *thumbImage = [UIImage imageNamed:@"slider-cap.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateHighlighted];
    
    [[UIProgressView appearance] setProgressTintColor:[UIColor colorWithPatternImage:minImage]];
    [[UIProgressView appearance] setTrackTintColor:[UIColor colorWithPatternImage:maxImage]];
    
}
*/

/*
-(void)iPhoneInit {
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
	
    UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:0];
	
    UIImage* icon1 = [UIImage imageNamed:@"icon1.png"];
    UITabBarItem *updatesItem = [[UITabBarItem alloc] initWithTitle:@"Recipes" image:icon1 tag:0];
    [updatesItem setFinishedSelectedImage:icon1 withFinishedUnselectedImage:icon1];
    
    [navigationController setTabBarItem:updatesItem];
    
    
    UIImage* icon2 = [UIImage imageNamed:@"icon2.png"];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Steps" image:icon2 tag:1] ;
    [item2 setFinishedSelectedImage:icon2 withFinishedUnselectedImage:icon2];
    
    UIViewController* controller2 = [[tabBarController viewControllers] objectAtIndex:1];
    [controller2 setTabBarItem:item2];
    
    
    UIViewController *controller3 = [[tabBarController viewControllers] objectAtIndex:2];
    
    UIImage* icon3 = [UIImage imageNamed:@"icon3.png"];
    
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"Elements" image:icon3 tag:2] ;
    [item3 setFinishedSelectedImage:icon3 withFinishedUnselectedImage:icon3];
    [controller3 setTabBarItem:item3];
    
    UIViewController *controller4 = [[tabBarController viewControllers] objectAtIndex:3];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"Label 4" image:icon3 tag:3];
    [item4 setFinishedSelectedImage:icon3 withFinishedUnselectedImage:icon3];
    [controller4 setTabBarItem:item4];
}
 */

@end
