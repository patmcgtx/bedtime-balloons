//
//  KTRandomGenerator.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/20/14.
//
//

#import "KTRandomGenerator.h"

@implementation KTRandomGenerator

+(NSInteger) randomIntBetween:(NSInteger)low and:(NSInteger)high {
    u_int32_t low32 = (u_int32_t) low;
    u_int32_t high32 = (u_int32_t) high;
    return low + arc4random_uniform(high32 - low32 + 1);
}

@end
