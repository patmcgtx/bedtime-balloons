//
//  DataSource.h
//
//  Created by Valentin Filip on 10.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+ (NSArray *)collections;

+ (NSArray *)details;

+ (NSArray *)categories;

@end
