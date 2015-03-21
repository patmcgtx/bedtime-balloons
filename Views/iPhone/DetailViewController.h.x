//
//  DetailViewController.h
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"

@interface DetailViewController : UIViewController <UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *parentScrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet SMPageControl *pageControl;

@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;


@end
