//
//  ElementsViewController.m
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ElementsViewController.h"
#import "ADVPercentProgressBar.h"
#import "ADVTheme.h"

@interface ElementsViewController ()

@property (nonatomic, strong) ADVPercentProgressBar *progressBarPercent;

@end

@implementation ElementsViewController

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
    
	self.progressBarPercent = [[ADVPercentProgressBar alloc] initWithFrame:CGRectMake(20, 197, 270, 43)];
    self.progressBarPercent.progress = 0.5;
    [self.view addSubview:self.progressBarPercent];
    
    self.view.tintColor = [ADVTheme mainColor];
    
    UIFont* labelFont = [UIFont fontWithName:[ADVTheme boldFont] size:12.0f];
    self.progressLabel.font = labelFont;
    self.sliderLabel.font = labelFont;
    self.switchLabel.font = labelFont;
    self.segmentedLabel.font = labelFont;
    self.buttonLabel.font = labelFont;
    
    UIColor* labelColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.sliderLabel.textColor = labelColor;
    self.progressLabel.textColor = labelColor;
    self.switchLabel.textColor = labelColor;
    self.segmentedLabel.textColor = labelColor;
    self.buttonLabel.textColor = labelColor;
    
    self.buttonOne.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:16.0f];
    self.buttonTwo.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:16.0f];
}

- (IBAction)sliderValueChanged:(id)sender {
    if([sender isKindOfClass:[UISlider class]]) {
        UISlider *s = (UISlider*)sender;
        if(s.value >= 0.0 && s.value <= 1.0) {
            self.progressBarPercent.progress = s.value;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
