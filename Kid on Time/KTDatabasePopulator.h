//
//  KTDataPopulator.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class has the job of inserting data into an empty database.
 */
@interface KTDatabasePopulator : NSObject

- (void) populateDbIfEmpty;

@end
