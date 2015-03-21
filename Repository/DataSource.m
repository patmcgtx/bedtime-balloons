//
//  DataSource.m
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

+ (NSArray *)collections
{
    return @[
             @{
                 @"image": @"collections1",
                 @"company": @"DIESEL",
                 @"details": @"DIESEL POLO NECK T-SHIRT",
                 @"price": @"79€",
                 @"dates": @"27 MAY - 3 JUN",
                 @"views": @"30",
                 @"hearts": @"24",
                 @"bags": @"14"
                 },
             @{
                 @"image": @"collections2",
                 @"company": @"DIESEL",
                 @"details": @"DIESEL POLO NECK T-SHIRT",
                 @"price": @"79€",
                 @"dates": @"27 MAY - 3 JUN",
                 @"views": @"18",
                 @"hearts": @"14",
                 @"bags": @"32"
                 },
             @{
                 @"image": @"collections3",
                 @"company": @"DIESEL",
                 @"details": @"DIESEL POLO NECK T-SHIRT",
                 @"price": @"79€",
                 @"dates": @"21 MAY - 3 JUL",
                 @"views": @"32",
                 @"hearts": @"41",
                 @"bags": @"23"
                 },
             @{
                 @"image": @"collections4",
                 @"company": @"DIESEL",
                 @"details": @"DIESEL POLO NECK T-SHIRT",
                 @"price": @"79€",
                 @"dates": @"5 MAR - 3 APR",
                 @"views": @"46",
                 @"hearts": @"52",
                 @"bags": @"34"
                 },
             @{
                 @"image": @"collections5",
                 @"company": @"DIESEL",
                 @"details": @"DIESEL POLO NECK T-SHIRT",
                 @"price": @"79€",
                 @"dates": @"22 DEC - 9 JAN",
                 @"views": @"52",
                 @"hearts": @"64",
                 @"bags": @"22"
                 },
             @{
                 @"image": @"collections6",
                 @"company": @"DIESEL",
                 @"details": @"DIESEL POLO NECK T-SHIRT",
                 @"price": @"79€",
                 @"dates": @"15FEB - 23MAR",
                 @"views": @"51",
                 @"hearts": @"23",
                 @"bags": @"44"
                 },
             ];
}

+ (NSArray *)details
{
    return @[
             @{
                 @"image": @"Details1"
                 },
             @{
                 @"image": @"Details2"
                 },
             @{
                 @"image": @"Details3"
                 },
             ];
}

+ (NSArray *)categories
{
    return @[
             @{@"title": @"SHOP WOMEN'S",
               @"value" : @[@"CLOTHING", @"SHOES", @"SANDALS", @"SNEAKERS AND ATHLETIC SHOES", @"SHIRTS AND TOPS"]
               },
             @{@"title": @"SHOP MEN'S",
                 @"value" : @[@"CLOTHING", @"SHOES", @"SANDALS", @"SNEAKERS AND ATHLETIC SHOES", @"SHIRTS AND TOPS"]
                 },
             @{@"title": @"SHOP KID'S",
               @"value" : @[@"BOYS CLOTHING", @"GIRLS CLOTHING", @"BOYS SHOES", @"GIRLS SHOES"]
               }
             ];
}

@end
