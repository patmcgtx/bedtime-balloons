//
//  KTDataAccess.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTDataAccess.h"
#import "RTSLog.h"
#import "KTErrorReporter.h"

@implementation KTDataAccess

@synthesize storeURL;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize taskQueries = _taskQueries;
@synthesize themeQueries = _themeQueries;

static KTDataAccess* _sharedInstance = nil;

// The singleton stuff was copied from some sample code somehere; 
// I don't fully understand it. :-\
#pragma mark - Singleton support

+ (KTDataAccess*) sharedInstance {
    
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ _sharedInstance = [[self alloc] init]; });
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Properties

-(KTTaskQueries*) taskQueries
{
    if ( ! _taskQueries ) 
    {
        _taskQueries = [[KTTaskQueries alloc] initWithMOC:self.managedObjectContext];
    }
    
    return _taskQueries;
}

-(KTThemeQueries*) themeQueries
{
    if ( ! _themeQueries ) 
    {
        _themeQueries = [[KTThemeQueries alloc] initWithMOC:self.managedObjectContext];
    }
    
    return _themeQueries;
}

-(KTRoutineQueries*) routineQueries
{
    if ( ! _routineQueries )
    {
        _routineQueries = [[KTRoutineQueries alloc] initWithMOC:self.managedObjectContext];
    }
    
    return _routineQueries;
}

#pragma mark - Common util methods

- (void) commitChanges
{
    // Doesn't matter which DAO does the commit; just pick one
    [self.taskQueries commitChanges];
}


#pragma mark - Core Data stuff

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KidOnTime" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    LOG_INFO(@"MOM @ %@", [momURL path]);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    LOG_INFO(@"store @ %@", [self.storeURL path]);
    
    // handle db upgrade
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:options error:&error]) {
        /*
         TODO...
         
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSString* debugInfo = [NSString stringWithFormat:@"Error committing db changes %@, %@", error.localizedDescription, error.localizedFailureReason];
        [[KTErrorReporter sharedReporter] warnUserWithMessageKey:@"error.db.missing.persistentstore" error:error debugInfo:debugInfo];
    }
    
    return _persistentStoreCoordinator;
}

@end
