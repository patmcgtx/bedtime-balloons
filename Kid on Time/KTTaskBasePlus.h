//
//  KTTaskPrototypePlus.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTTaskBase.h"

/*
 * Add methods to the CoreData-generated task entity class.
 * This class adds custom logic to do calculations, manipluations, etc.
 * on the core data.
 */
@interface KTTaskBase (plusMethods)

-(NSString*) localizedShortTimeDescription;

-(NSUInteger) maxTimeInMinutes;
-(NSUInteger) minTimeInMinutes;
-(BOOL) hasTimeLimit;
-(BOOL) hasTimeMin;
-(BOOL) isCustomTask;

/*
  Gets a short version of this object's obejctId, which is normally
 represented as a full URI. But I can't use a whole URI for my purposes,
 so I need a shorter id.
 */
-(NSString*) shortId;

@end
