//
//  CollectionCell.h
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell


@property (nonatomic, weak) IBOutlet UIImageView* productImageView;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* dateLabel;
@property (nonatomic, weak) IBOutlet UILabel* likesLabel;
@property (nonatomic, weak) IBOutlet UILabel* viewsLabel;
@property (nonatomic, weak) IBOutlet UILabel* purchasesLabel;
@property (nonatomic, weak) IBOutlet UIImageView* likesImageView;
@property (nonatomic, weak) IBOutlet UIImageView* viewsImageView;
@property (nonatomic, weak) IBOutlet UIImageView* purchasesImageView;

-(void)updateCellWithData:(NSDictionary*)data;

@end
