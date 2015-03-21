//
//  KTHelpTipsController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/6/13.
//
//

#import "KTHelpController.h"
#import "ADVTheme.h"

#define KT_HELP_CONTROLLER_SECTION_OVERVIEW 0
#define KT_HELP_CONTROLLER_SECTION_SETUP 1
#define KT_HELP_CONTROLLER_SECTION_TIPS 2

#define KT_HELP_CONTROLLER_FILENAME_OVERVIEW @"help-overview.html"
#define KT_HELP_CONTROLLER_FILENAME_SETUP @"help-setup.html"
#define KT_HELP_CONTROLLER_FILENAME_TIPS @"help-tips.html"

@interface KTHelpController ()

@property (nonatomic, strong) NSURL* baseDocURL;

- (IBAction)pickedNewSection:(UISegmentedControl *)sender forEvent:(UIEvent *)event;

@end

@implementation KTHelpController

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
    
    self.webView.backgroundColor = [ADVTheme viewBackgroundColor];
    self.title = NSLocalizedString(@"tab.help.title", nil);
    
    // The base url lets us load local images, css, etc.
    NSString* localBundlePath = [[NSBundle mainBundle] bundlePath];
    self.baseDocURL = [NSURL fileURLWithPath:localBundlePath];

    // Show overview on load
    [self showLocalWebFile:KT_HELP_CONTROLLER_FILENAME_OVERVIEW];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

#pragma mark - Actions

- (IBAction)pickedNewSection:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    
    switch (sender.selectedSegmentIndex) {
            
        case KT_HELP_CONTROLLER_SECTION_OVERVIEW:
            [self showLocalWebFile:KT_HELP_CONTROLLER_FILENAME_OVERVIEW];
            break;
            
        case KT_HELP_CONTROLLER_SECTION_TIPS:
            [self showLocalWebFile:KT_HELP_CONTROLLER_FILENAME_TIPS];
            break;
            
        case KT_HELP_CONTROLLER_SECTION_SETUP:
            [self showLocalWebFile:KT_HELP_CONTROLLER_FILENAME_SETUP];
            break;
            
        default:
            break;
    }
}

#pragma mark - Internal helpers

-(void) showLocalWebFile:(NSString*) fileName {
    NSURL* localFileURL = [NSURL URLWithString:fileName relativeToURL:self.baseDocURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:localFileURL];
    [self.webView loadRequest:request];
}

@end
