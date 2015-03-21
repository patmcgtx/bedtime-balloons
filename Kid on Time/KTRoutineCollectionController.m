//
//  KTRoutineCollectionController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 1/19/14.
//
//

#import "KTRoutineCollectionController.h"
#import "KTConstants.h"
#import "ADVTheme.h"
#import "KTRoutineCell.h"
#import "KTRoutinePlus.h"
#import "KTRoutineInfoController.h"
#import "KTRoutineCollectionDataSource.h"
#import "KTErrorReporter.h"

@interface KTRoutineCollectionController ()

@property (nonatomic,strong) UIBarButtonItem* editButton;
@property (nonatomic,strong) UIBarButtonItem* doneButton;

@property (nonatomic, strong) KTRoutineCollectionDataSource* dataSource;

-(void) turnEditingOn;
-(void) turnEditingOff;

-(void) showActionSheet:(NSNotification*) notification;
-(void) handleRoutineAdded:(NSNotification*) notification;

@end

@implementation KTRoutineCollectionController

@synthesize isEditing = _isEditing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"tab.routines.title", nil);
    
    self.dataSource = [[KTRoutineCollectionDataSource alloc] initForPresentingElement:self collectionView:self.collectionView];
    self.collectionView.dataSource = self.dataSource;
    
    // Set up the collections view as per Store Mob template code
    self.collectionView.backgroundColor = [ADVTheme viewBackgroundColor];
    self.collectionView.draggable = YES;
    
    // Set up edit button
    self.navigationItem.title = NSLocalizedString(@"nav.routines", nil);
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self
                                                                    action:@selector(turnEditingOn)];
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(turnEditingOff)];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActionSheet:)
                                                 name:KTNotificationDoPresentActionSheet
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRoutineAdded:)
                                                 name:KTNotificationDidAddRoutine
                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isEditing = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO Dispose of any resources that can be recreated.
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
	if ([segue.identifier isEqualToString:@"routineListToRoutineInfo"]) {

        NSAssert([segue.destinationViewController isKindOfClass:[KTRoutineInfoController class]],
                 @"routine list -> routine info segue going to an unexpected controller type");
		KTRoutineInfoController* destinationRoutineInfoController = (KTRoutineInfoController*) segue.destinationViewController;
        
        if ( [sender isKindOfClass:[KTRoutine class]] ) {
            KTRoutine* sendingRoutine = (KTRoutine*) sender;
            destinationRoutineInfoController.routineEntity = sendingRoutine;
            destinationRoutineInfoController.startInEditMode = YES;
        }
        else if ( [sender isKindOfClass:[KTRoutineCell class]] ) {
            KTRoutineCell* tappedRoutineCell = (KTRoutineCell*) sender;
            destinationRoutineInfoController.routineEntity = tappedRoutineCell.routineEntity;
        }
	}
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // No navigation while editing
    return ! self.isEditing;
}

#pragma mark - KTEditable

-(void) setIsEditing:(BOOL)isEditing {
    
    _isEditing = isEditing;
    
    self.dataSource.addRoutinesCell.userInteractionEnabled = !isEditing;
    self.dataSource.addRoutinesCell.alpha = (isEditing ? 0.5 : 1.0);
    
    if ( isEditing ) {
        for ( NSIndexPath* routineCellPath in [self.collectionView indexPathsForVisibleItems] ) {
            
            UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:routineCellPath];
            
            if ( [cell isKindOfClass:[KTRoutineCell class]] ) {
                KTRoutineCell* routineCell = (KTRoutineCell*) cell;
                routineCell.isEditing = YES;
            }
        }
        
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }
    else {
        for ( NSIndexPath* routineCellPath in [self.collectionView indexPathsForVisibleItems] ) {
            
            UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:routineCellPath];
            
            if ( [cell isKindOfClass:[KTRoutineCell class]] ) {
                KTRoutineCell* routineCell = (KTRoutineCell*) cell;
                routineCell.isEditing = NO;
            }
        }
        
        self.navigationItem.rightBarButtonItem = self.editButton;
    }
}

#pragma mark - Notifications

-(void) showActionSheet:(NSNotification*) notification {
    
    // Someone has requested to show an action sheet.  We have no idea what the content of the action sheet is
    // or what it is for.  Our only job is to throw it up since we hve a toolbar to hook it to.    
    UIActionSheet* actionSheet = [[notification userInfo]
                                  objectForKey:KTKeyActionSheet];
    NSAssert(actionSheet, @"No action sheet found on show-action-sheet notification");
    
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

-(void) handleRoutineAdded:(NSNotification*) notification {
    
    /*
    KTRoutine* addedRoutine = [[notification userInfo]
                               objectForKey:KTKeyRoutineEntity];
    NSAssert(addedRoutine, @"No routine found on KTRoutineCollectionController added-routine notification");
     */
}

#pragma mark - Internal helpers

-(void) turnEditingOn {
    self.isEditing = YES;
}

-(void) turnEditingOff {
    self.isEditing = NO;
}

@end
