//
//  ElementsViewController.h
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElementsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UISlider *sliderView;

@property (strong, nonatomic) IBOutlet UIButton *buttonOne;
@property (strong, nonatomic) IBOutlet UIButton *buttonTwo;

@property (strong, nonatomic) IBOutlet UILabel* sliderLabel;
@property (strong, nonatomic) IBOutlet UILabel* progressLabel;
@property (strong, nonatomic) IBOutlet UILabel* segmentedLabel;
@property (strong, nonatomic) IBOutlet UILabel* switchLabel;
@property (strong, nonatomic) IBOutlet UILabel* buttonLabel;

- (IBAction)sliderValueChanged:(id)sender;


@end
