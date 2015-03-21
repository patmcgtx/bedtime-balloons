//
//  DetailViewController.h
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTTask.h"
#import "KTTaskTimeDoubleSlider.h"
#import "KTTaskImageEditorDelegate.h"

@interface KTTaskDetailController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, KTTaskTimeDoubleSliderDelegate, KTImageEditorDelegate>

@property (nonatomic, strong) KTTask* taskEntity;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet KTTaskTimeDoubleSlider *timeRangerSlider;
@property (weak, nonatomic) IBOutlet UILabel *taskMinTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskMaxTimeLabel;

@end
