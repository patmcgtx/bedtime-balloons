//
//  KTTopTabBarController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/28/14.
//
//

#import "KTTopTabBarController.h"

#define KT_TAB_BAR_INDEX_ROUTINES 0
#define KT_TAB_BAR_INDEX_HELP 1
#define KT_TAB_BAR_INDEX_ABOUT 2

@interface KTTopTabBarController ()

@end

@implementation KTTopTabBarController

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
    
    // See ADVTheme for global settings for tab bars
    
    // Unfortunately, this stuff does not "take" in Interface Builder / Storyboards
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barStyle = UIBarStyleDefault;
    
    UITabBarItem *item0 = [self.tabBar.items objectAtIndex:0];
    item0.image = [[UIImage imageNamed:@"tabbar-routines"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.selectedImage = [[UIImage imageNamed:@"tabbar-routines-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:1];
    item1.image = [[UIImage imageNamed:@"tabbar-help"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"tabbar-help-selected"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:2];
    item2.image = [[UIImage imageNamed:@"tabbar-about"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"tabbar-about-selected"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // Localize the sub-controllers
    if ( [self.viewControllers count] > KT_TAB_BAR_INDEX_ABOUT ) { // Just in case!
        
        UIViewController* vc = [self.viewControllers objectAtIndex:KT_TAB_BAR_INDEX_ROUTINES];
        vc.title = NSLocalizedString(@"tab.routines.title", nil);

        vc = [self.viewControllers objectAtIndex:KT_TAB_BAR_INDEX_HELP];
        vc.title = NSLocalizedString(@"tab.help.title", nil);

        vc = [self.viewControllers objectAtIndex:KT_TAB_BAR_INDEX_ABOUT];
        vc.title = NSLocalizedString(@"tab.about.title", nil);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
