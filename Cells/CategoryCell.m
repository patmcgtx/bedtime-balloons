//
//  CategoryCell.m
//  StoreMob
//
//  Created by Tope Abayomi on 05/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "CategoryCell.h"
#import "ADVTheme.h"

@implementation CategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{

    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [ADVTheme mainColor];
    self.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:12.0f];
    
    self.contentView.backgroundColor = [ADVTheme viewBackgroundColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
