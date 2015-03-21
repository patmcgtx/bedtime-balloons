//
//  KTRoutineQueries.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/3/14.
//
//

#import <Foundation/Foundation.h>
#import "KTBaseDAO.h"

@interface KTRoutineQueries : KTBaseDAO

-(NSArray*) allRoutinesInOrder;

@end
