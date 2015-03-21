//
//  CollectionCell.m
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "CollectionCell.h"
#import "ADVTheme.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    
    self.likesImageView.image = [UIImage imageNamed:@"pink-heart"];
    self.viewsImageView.image = [UIImage imageNamed:@"pink-eye"];
    self.purchasesImageView.image = [UIImage imageNamed:@"pink-bag"];
    
    self.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:11.0f];
    self.dateLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:11.0f];
    self.viewsLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:11.0f];
    self.likesLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:11.0f];
    self.purchasesLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:11.0f];
    
    self.contentView.tintColor = [ADVTheme mainColor];
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.dateLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.likesLabel.textColor = [ADVTheme mainColor];
    self.viewsLabel.textColor = [ADVTheme mainColor];
    self.purchasesLabel.textColor = [ADVTheme mainColor];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}

-(void)updateCellWithData:(NSDictionary*)data{
    
    self.productImageView.image = [UIImage imageNamed:data[@"image"]];
    self.titleLabel.text = data[@"company"];
    self.dateLabel.text = data[@"dates"];
    self.likesLabel.text = data[@"hearts"];
    self.viewsLabel.text = data[@"views"];
    self.purchasesLabel.text = data[@"bags"];
}

/*
 @"image": @"collections2",
 @"company": @"DIESEL",
 @"details": @"DIESEL POLO NECK T-SHIRT",
 @"price": @"79€",
 @"dates": @"27MAY - 3JUN",
 @"views": @"18",
 @"hearts": @"14",
 @"bags": @"32"
 */
@end
