//
//  KTRoutineCollectionDataSource.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/2/14.
//
//

#import "KTRoutineCollectionDataSource.h"
#import "KTRoutinePlus.h"
#import "KTDataAccess.h"
#import "KTRoutineCell.h"
#import "KTConstants.h"
#import "RTSIndexPath.h"
#import "KTRoutinePlus.h"
#import "KTAddRoutineCell.h"

@interface KTRoutineCollectionDataSource ()

@property (nonatomic, strong) NSIndexPath* indexPathForAddRoutineCell;
@property (nonatomic, strong) NSArray* routineEntities;

@property (nonatomic, weak) id<KTEditable> presentingElement;
@property (nonatomic, weak) UICollectionView* collectionView;

-(void) handleRoutineDeleted:(NSNotification*) notification;
-(void) handleRoutineAdded:(NSNotification*) notification;
-(void) handleRoutineUpdated:(NSNotification*) notification;

-(void) invalidateBackingData;
-(BOOL) isIndexPathForAddRoutineCell:(NSIndexPath*) indexPath;

@end

@implementation KTRoutineCollectionDataSource

@synthesize routineEntities = _routineEntities;

- (instancetype)initForPresentingElement:(id<KTEditable>) presenting
                          collectionView:(UICollectionView*) collectView {
    
    self = [super init];
    
    if (self) {
        
        _routineEntities = nil;
        
        _presentingElement = presenting;
        NSAssert(_presentingElement, @"No presenting element provided to data source");
        
        _collectionView = collectView;
        NSAssert(_collectionView, @"No collection view provided to data source");

        self.indexPathForAddRoutineCell = [NSIndexPath indexPathForRow:0 inSection:0];
        
        // Register for CRUD notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRoutineDeleted:)
                                                     name:KTNotificationDidDeleteRoutine
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRoutineAdded:)
                                                     name:KTNotificationDidAddRoutine
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRoutineUpdated:)
                                                     name:KTNotificationRoutineNameDidChange
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRoutineUpdated:)
                                                     name:KTNotificationRoutineTasksDidChange
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Add one for the "add" button
    return [self.routineEntities count] + 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* retval = nil;
    
    if ( [self isIndexPathForAddRoutineCell:indexPath] ) {
        
        KTAddRoutineCell* addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addRoutineCell" forIndexPath:indexPath];
        addCell.addRoutineLabel.text = NSLocalizedString(@"action.routine.add", nil);
        
        self.addRoutinesCell = retval;
        retval = addCell;
    }
    else {
        KTRoutineCell* routineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"routineCell" forIndexPath:indexPath];
        
        KTRoutine* routine = [self routineForIndexPath:indexPath];
        [routineCell prepareForRoutine:routine isEditable:self.presentingElement.isEditing];
        
        retval = routineCell;
    }
    
    return retval;
}


#pragma mark - UICollectionViewDataSource_Draggable

- (void)collectionView:(UICollectionView *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath {

    // Adjust indiced for the "add routine" button
    [KTRoutine moveRoutineAtPosition:fromIndexPath.row-1 toPosition:toIndexPath.row-1 commit:YES];
    
    // Invalidate the routine list so we get a fresh copy next time we need it
    self.routineEntities = nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return ![self isIndexPathForAddRoutineCell:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath {
    return ![self isIndexPathForAddRoutineCell:toIndexPath];
}

#pragma mark - Notification handlers

-(void) handleRoutineDeleted:(NSNotification*) notification {

    KTRoutine* deletedRoutine = [[notification userInfo] objectForKey:KTKeyRoutineEntity];
    NSAssert(deletedRoutine, @"No routine found on deleted-routine notification");
    
    NSIndexPath* routineIndex = [self indexPathForRoutine:deletedRoutine];
    
    [self invalidateBackingData];
    
    // And remove it from the collection view
    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:routineIndex]];
}

-(void) handleRoutineAdded:(NSNotification*) notification {

    [self invalidateBackingData];
    
    // And a spot to the collection view just after the "add routine" button.
    // We just add a spot for it; we don't care about the specifc routine here.
    [self.collectionView insertItemsAtIndexPaths:
     [NSArray arrayWithObject:[NSIndexPath indexPathForItem:1 inSection:0]]];
}

-(void) handleRoutineUpdated:(NSNotification*) notification {

    KTRoutine* updatedRoutine = [[notification userInfo] objectForKey:KTKeyRoutineEntity];
    NSAssert(updatedRoutine, @"No routine found on updated-routine notification");
    
    NSIndexPath* routineIndex = [self indexPathForRoutine:updatedRoutine];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:routineIndex]];
}


#pragma mark - Properties

-(NSArray*) routineEntities
{
    // Lazy loading of routine data
    if ( ! _routineEntities )
    {
        _routineEntities = [[[KTDataAccess sharedInstance] routineQueries] allRoutinesInOrder];
        NSAssert(_routineEntities, @"Failed to load the routines");
    }
    
    return _routineEntities;
}

#pragma mark - Internal helpers

// Forces the routine data to reloaded from the database next time it is needed.
// Call this when the ~set~ of all routines has changed, not when the particulars
// of a known routine hs changed.
-(void) invalidateBackingData {
    _routineEntities = nil;
}

-(BOOL) isIndexPathForAddRoutineCell:(NSIndexPath*) indexPath {
    return ([self.indexPathForAddRoutineCell compare:indexPath] == NSOrderedSame);
}

- (KTRoutine*) routineForIndexPath:(NSIndexPath *)indexPath {
	return [self.routineEntities objectAtIndex:indexPath.row - 1]; // Subtract one for "add" button
}

- (NSIndexPath*) indexPathForRoutine:(KTRoutine *)routine {
    NSUInteger routineArrayIndex = [self.routineEntities indexOfObject:routine];
	return [NSIndexPath indexPathForItem:routineArrayIndex+1 inSection:0]; // Add one for "add" button
}

@end
