//
//  KTPrivacyPolicyController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/5/14.
//
//

#import "KTPrivacyPolicyController.h"
#import "ADVTheme.h"

@interface KTPrivacyPolicyController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL* privacyPolicyURL;
@property (nonatomic, strong) NSURL* baseDocURL;

@end

@implementation KTPrivacyPolicyController

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
    self.title = NSLocalizedString(@"privacy.policy", nil);
    
    // The base url lets us load local images, css, etc.
    NSString* localBundlePath = [[NSBundle mainBundle] bundlePath];
    self.baseDocURL = [NSURL fileURLWithPath:localBundlePath];
    
    [self showLocalWebFile:@"privacy.html"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal helpers

-(void) showLocalWebFile:(NSString*) fileName {
    NSURL* localFileURL = [NSURL URLWithString:fileName relativeToURL:self.baseDocURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:localFileURL];
    [self.webView loadRequest:request];
}

@end
