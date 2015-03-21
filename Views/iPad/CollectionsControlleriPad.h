//
//  CollectionsControlleriPad.h
//  StoreMob
//
//  Created by Tope Abayomi on 05/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionsControlleriPad : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView* productCollectionView;

@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* productLayout;

@property (nonatomic, weak) IBOutlet UITableView* categoryTableView;

@property (nonatomic, weak) IBOutlet UILabel* sizeLabel;

@property (nonatomic, weak) IBOutlet UILabel* priceLabel;

@property (nonatomic, weak) IBOutlet UISegmentedControl* sizeSegmentControl;

@property (nonatomic, weak) IBOutlet UISlider *priceSlider;

@property (nonatomic, strong) NSArray* products;

@property (nonatomic, strong) NSArray* categories;

- (IBAction)sliderValueChanged:(id)sender;

@end
