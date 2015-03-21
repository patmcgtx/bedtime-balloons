//
//  KTDataAccess.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTTaskQueries.h"
#import "KTThemeQueries.h"
#import "KTRoutineQueries.h"

/**
 * This singleton class provides a simple way to access the various
 * DAO classes.  It keep an instance of each type of DAO and also
 * add some common utility methods such as to commit the transaction.
 *
 * This class lets me present the various DAOs with the advantages of a 
 * singleton (mosty just simple, global access) without imposing the
 * negative constraints of a singleton on the individual DAO classes
 * themselves.  So the DAOs can still be instantiated individually
 * outside of this class, even with their own db context if need be.
 * This class almost acts liek a factory of sorts, and it achieves 
 * the key goal of making the controlers much easier to write
 * (no need to instantiate / initialize DAO objects).
 */
@interface KTDataAccess : NSObject

@property (nonatomic, strong) KTTaskQueries* taskQueries;
@property (nonatomic, strong) KTThemeQueries* themeQueries;
@property (nonatomic, strong) KTRoutineQueries* routineQueries;

@property (nonatomic, strong) NSURL* storeURL;
@property (readonly, strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

+ (KTDataAccess*) sharedInstance;

- (void) commitChanges;

@end
