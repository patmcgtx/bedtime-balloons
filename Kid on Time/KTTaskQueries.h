//
//  KTTaskDAO.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTBaseDAO.h"
#import "KTTaskPrototype.h"
#import "KTTask.h"

@interface KTTaskQueries : KTBaseDAO

- (id)initWithMOC:(NSManagedObjectContext*)moc;

-(NSArray*) getTaskPrototypes;
-(KTTaskPrototype*) getTaskPrototypeByType:(NSString*) prototypeName;
-(KTTask*) getTaskByObjectId:(NSManagedObjectID*) objectId;

@end
