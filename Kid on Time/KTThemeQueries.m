//
//  KTThemeDAO.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTThemeQueries.h"
#import "KTConstants.h"

@implementation KTThemeQueries

-(KTTheme*) themeByName:(NSString*) themeName
{
    // Pull the routines from the database using Core Data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Theme" 
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // Query by name
    NSPredicate* predicate = [NSPredicate
                              predicateWithFormat:
                              [NSString stringWithFormat:@"nameKey == \"%@\"", themeName]];
    request.predicate = predicate;
    
    // Execute the query
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext
                                            executeFetchRequest:request
                                            error:&error] mutableCopy];
    return (KTTheme*) [mutableFetchResults objectAtIndex:0];
}

-(NSArray*) availableThemes {
    
    // Pull all the prototypes from the database using Core Data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Theme"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    // Only pull in available (puchased) themes
    /*
    NSPredicate* predicate =
    [NSPredicate predicateWithFormat:@"isAvailable == YES"];
    request.predicate = predicate;
     */
    
    // Display purchased themes first, then by display order
    NSSortDescriptor *sortByPurchased = [NSSortDescriptor sortDescriptorWithKey:@"isPurchased" ascending:NO];
    NSSortDescriptor *sortByDisplayOrder = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:sortByPurchased, sortByDisplayOrder, nil];
    
    // Execute the query
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext
                                            executeFetchRequest:request error:&error] mutableCopy];
    return mutableFetchResults;
}

@end
