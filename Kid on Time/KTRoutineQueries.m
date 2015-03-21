//
//  KTRoutineQueries.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/3/14.
//
//

#import "KTRoutineQueries.h"
#import <CoreData/CoreData.h>

@implementation KTRoutineQueries

- (id)initWithMOC:(NSManagedObjectContext*)moc;
{
    self = [super initWithMOC:moc];
    if (self) {
        // Custom attrs here
    }
    return self;
}

-(NSArray*) allRoutinesInOrder {

    // Pull the routines from the database using Core Data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Routine"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // Sort the routines by name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Execute the query
    NSError *error = nil;
    NSArray *retval = [self.managedObjectContext executeFetchRequest:request error:&error];
    return retval;;
}

@end
