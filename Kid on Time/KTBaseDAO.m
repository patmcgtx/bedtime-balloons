//
//  KTBaseDAO.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTBaseDAO.h"
#import "RTSLog.h"
#import "KTErrorReporter.h"

@implementation KTBaseDAO

@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithMOC:(NSManagedObjectContext*)moc
{
    self = [super init];
    if (self) {
        _managedObjectContext = moc;
    }
    return self;
    
}

- (void) commitChanges
{
    NSError *error = nil;
    
    if (self.managedObjectContext != nil)
    {
        if ([self.managedObjectContext hasChanges])
        {
            if (![self.managedObjectContext save:&error])
            {
                NSString* debugInfo = [NSString stringWithFormat:@"Error committing db changes %@, %@", error, [error userInfo]];
                [[KTErrorReporter sharedReporter] warnUserWithMessageKey:@"error.db.commit.failed" error:error debugInfo:debugInfo];
            } 
        }
        else
        {
            LOG_DATABASE(@"No db changes to commit.");
        }
    }
    else 
    {
        [[KTErrorReporter sharedReporter] warnUserWithMessageKey:@"error.db.commit.failed" error:error debugInfo:@"nil managedObjectContext"];
    }
}

- (void)deleteObject:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
}

@end
