//
//  RTSIndexPath.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/3/14.
//
//

#import <Foundation/Foundation.h>

// Expands the NSIndexPath class to add debugging string support
@interface NSIndexPath (RTSIndexPath)

- (NSString *)indexPathString;

@end
