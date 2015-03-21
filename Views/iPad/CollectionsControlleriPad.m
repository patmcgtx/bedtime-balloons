//
//  CollectionsControlleriPad.m
//  StoreMob
//
//  Created by Tope Abayomi on 05/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "CollectionsControlleriPad.h"
#import "CollectionCell.h"
#import "CategoryCell.h"
#import "Datasource.h"
#import "ADVTheme.h"

@interface CollectionsControlleriPad ()

@end

@implementation CollectionsControlleriPad

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
    
    self.productCollectionView.dataSource = self;
    self.productCollectionView.delegate = self;
    self.productCollectionView.backgroundColor = [UIColor clearColor];

    self.categoryTableView.dataSource = self;
    self.categoryTableView.delegate = self;
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.categoryTableView.backgroundColor = [ADVTheme viewBackgroundColor];
    
    self.navigationItem.title = @"COLLECTIONS";
    self.view.backgroundColor = [ADVTheme viewBackgroundColor];
    
    self.productLayout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    self.productLayout.itemSize = CGSizeMake(150, 230);
    self.productLayout.minimumInteritemSpacing = 3;
    self.productLayout.minimumLineSpacing = 10;
    
    self.products = [DataSource collections];
    self.categories = [DataSource categories];
    
    UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shopping-bag"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIFont* labelFont = [UIFont fontWithName:[ADVTheme boldFont] size:12.0f];
    self.sizeLabel.font = labelFont;
    self.priceLabel.font = labelFont;
    
    UIColor* labelColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.sizeLabel.textColor = labelColor;
    self.priceLabel.textColor = labelColor;
    
    self.sizeSegmentControl.tintColor = [ADVTheme mainColor];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.products.count*3;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    NSDictionary* data = self.products[indexPath.row%3];
    [cell updateCellWithData:data];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    headerView.backgroundColor = [[ADVTheme viewBackgroundColor] colorWithAlphaComponent:0.95f];
    
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithWhite:0.6f alpha:1.0f];
    headerLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:12.0f];
    
    headerLabel.text = ((NSDictionary*)self.categories[section])[@"title"];
    [headerView addSubview:headerLabel];
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.categories.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    NSDictionary* category = self.categories[section];
    NSArray* subCategories = category[@"value"];
    
    return subCategories.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    
    NSDictionary* category = self.categories[indexPath.section];
    NSArray* subCategories = category[@"value"];
    
    NSString* subCategoryTitle = subCategories[indexPath.row];
    
    cell.titleLabel.text = subCategoryTitle;
    
    return cell;

}

- (IBAction)sliderValueChanged:(id)sender {
    if([sender isKindOfClass:[UISlider class]]) {
        UISlider *s = (UISlider*)sender;
        if(s.value >= 0.0 && s.value < 0.3) {
            self.priceLabel.text = @"PRICE: $0 - $10";
        }
        else if(s.value >= 0.3 && s.value < 0.6) {
            self.priceLabel.text = @"PRICE: $10 - $25";
        }
        else if(s.value >= 0.6){
            self.priceLabel.text = @"PRICE: $25 - $100";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
