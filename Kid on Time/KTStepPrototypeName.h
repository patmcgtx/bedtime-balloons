//
//  KTStepPrototypeName.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KTStepPrototype;

@interface KTStepPrototypeName : NSManagedObject

@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) KTStepPrototype *stepPrototype;

@end
