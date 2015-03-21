//
//  RTSIndexPath.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/3/14.
//
//

#import "RTSIndexPath.h"

@implementation NSIndexPath (RTSIndexPath)

- (NSString *)indexPathString
{    
    NSMutableString *indexString = [NSMutableString stringWithFormat:@"%lu",(unsigned long)[self indexAtPosition:0]];
    for (int i = 1; i < [self length]; i++){
        [indexString appendString:[NSString stringWithFormat:@".%lu", (unsigned long)[self indexAtPosition:i]]];
    }
    return indexString;
}

@end
