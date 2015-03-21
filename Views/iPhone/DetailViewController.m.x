//
//  DetailViewController.m
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "DetailViewController.h"
#import "DataSource.h"
#import "ADVTheme.h"

@interface DetailViewController ()

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, strong) NSArray *info;

@end

@implementation DetailViewController

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
    
    //self.title = self.companyName;
    self.title = @"Lacoste";
    
    self.info = [DataSource details];
    
    [self.button setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [self.button setBackgroundImage:[UIImage imageNamed:@"button-pressed"] forState:UIControlStateHighlighted];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
    [self.pageControl setPageIndicatorImage:[UIImage imageNamed:@"pageControl-dot"]];
    [self.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"pageControl-dot-selected"]];
    self.pageControl.numberOfPages = self.info.count;
    
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    self.scrollView.delegate = self;
    
    CGFloat scrollContentWidth = 0;
    CGFloat scrollHeight = self.scrollView.bounds.size.height; // -20;
    CGFloat padding = (self.scrollView.bounds.size.width - scrollHeight) / 2;
    
    for (NSDictionary *image in self.info) {
        CGRect frame = CGRectMake(scrollContentWidth + padding + 33, (self.scrollView.bounds.size.height - scrollHeight)/2, 200, scrollHeight);
        
        UIImageView *preview = [[UIImageView alloc] initWithFrame:frame];
        preview.image = [UIImage imageNamed:[image objectForKey: @"image"]];
        scrollContentWidth += self.scrollView.bounds.size.width;
        
        [self.scrollView addSubview:preview];
    }
    [self.parentScrollView setScrollEnabled:YES];
    [self.parentScrollView setContentSize:self.contentView.frame.size];
    
    self.scrollView.contentSize = CGSizeMake(scrollContentWidth, scrollHeight);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (2 - 1), 0);
    
    [self scrollViewDidEndDecelerating:self.scrollView];
    
    self.sizeSegmentedControl.tintColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    UIImage* buttonImage = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage* buttonPressedImage = [[UIImage imageNamed:@"button-pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self.button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    self.button.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:18.0f];
    
    self.titleLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:15.0f];
    self.priceLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    self.colorLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:15.0f];
    self.quantityLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:15.0f];
    self.sizeLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:15.0f];

}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = ceil(scrollView.contentOffset.x / self.scrollView.bounds.size.width);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
