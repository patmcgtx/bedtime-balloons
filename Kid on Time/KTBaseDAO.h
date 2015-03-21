//
//  KTBaseDAO.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface KTBaseDAO : NSObject

@property (nonatomic, weak) NSManagedObjectContext* managedObjectContext;

- (id)initWithMOC:(NSManagedObjectContext*)moc;

- (void) commitChanges;

- (void)deleteObject:(NSManagedObject *)object;

@end
