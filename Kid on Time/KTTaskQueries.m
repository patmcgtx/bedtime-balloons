//
//  KTTaskDAO.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTaskQueries.h"
#import "KTTaskPlus.h"
#import "KTConstants.h"

@implementation KTTaskQueries

- (id)initWithMOC:(NSManagedObjectContext*)moc;
{
    self = [super initWithMOC:moc];
    if (self) {
        // Custom attrs here
    }
    return self;
}

-(NSArray*) getTaskPrototypes
{
    // Pull all the prototypes from the database using Core Data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskPrototype" 
                                              inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    // Get the results in the preferred order
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    // Execute the query
    NSError *error = nil;
    NSArray *retval = [self.managedObjectContext executeFetchRequest:request error:&error];
    return retval;
}

-(KTTaskPrototype*) getTaskPrototypeByType:(NSString*) prototypeName {

    KTTaskPrototype* retval = nil;
    
    // Pull the routines from the database using Core Data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskPrototype"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // Query by name
    NSPredicate* predicate = [NSPredicate
                              predicateWithFormat:
                              [NSString stringWithFormat:@"type == \"%@\"", prototypeName]];
    request.predicate = predicate;
    
    // Execute the query
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext
                                            executeFetchRequest:request
                                            error:&error] mutableCopy];

    if ( [mutableFetchResults count] > 0 ) {
        retval = (KTTaskPrototype*) [mutableFetchResults objectAtIndex:0];
    }
    
    return retval;
}

@end
