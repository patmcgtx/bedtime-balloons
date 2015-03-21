//
//  ViewController.m
//  StoreMob
//
//  Created by Tope Abayomi on 27/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "CollectionsController.h"
#import "CollectionCell.h"
#import "Datasource.h"
#import "ADVTheme.h"

@interface CollectionsController ()

@end

@implementation CollectionsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [ADVTheme viewBackgroundColor];
    
    self.navigationItem.title = @"COLLECTIONS";
    
    self.layout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    self.layout.itemSize = CGSizeMake(150, 230);
    self.layout.minimumInteritemSpacing = 3;
    self.layout.minimumLineSpacing = 10;
    
    self.collections = [DataSource collections];

    UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shopping-bag"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collections.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    NSDictionary* data = self.collections[indexPath.row];
    [cell updateCellWithData:data];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detail" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
