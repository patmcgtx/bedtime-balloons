//
//  KTErrorReporterController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/12/14.
//
//

#import "KTErrorReporterController.h"

@interface KTErrorReporterController ()

@property (weak, nonatomic) IBOutlet UITextView *errorMessageTextView;

- (IBAction)dismiss:(id)sender;

@end

@implementation KTErrorReporterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    self.errorMessageTextView.text = self.userErrorMessage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
