//
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/9/14.
//
//

#import "KTRoutineInfoController.h"
#import "DataSource.h"
#import "ADVTheme.h"
#import "RTSTimeUtils.h"
#import "KTTaskCell.h"
#import "KTTaskBasePlus.h"
#import "KTDataAccess.h"
#import "KTConstants.h"
#import "KTRoutinePlus.h"
#import "KTTaskDetailController.h"
#import "KTThemePlus.h"
#import "KTRoutineInfoHeaderView.h"
#import "RTSIndexPath.h"
#import "KTRunRoutineTaskController.h"
#import "KTRoutineAddTasksController.h"
#import "ELCImagePickerController.h"
#import "KTBlankSlateRoutineEditor.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "KTAddTaskCell.h"
#import "KTPhotoAccessChecker.h"
#import "GMImagePickerController.h"

#define KT_ROUTINE_PICK_TASKS NSLocalizedString(@"label.tasks.pick", nil)
#define KT_ROUTINE_TAKE_PHOTO NSLocalizedString(@"label.tasks.camera", nil)
#define KT_ROUTINE_PICK_IMAGES NSLocalizedString(@"label.tasks.photos", nil)

@interface KTRoutineInfoController ()

@property (strong, nonatomic) KTBlankSlateRoutineEditor* blankSlateEditor;
@property (strong, nonatomic) ELCImagePickerController* multiImagePicker;
@property (strong, nonatomic) UIImagePickerController* cameraImagePicker;

@property (strong, nonatomic) UIBarButtonItem* backButton;
@property (strong, nonatomic) UITapGestureRecognizer* hideKeyboardGestureRecognizer;

@property (weak, nonatomic) KTRoutineInfoHeaderView* headerView;
@property (nonatomic,strong) UIBarButtonItem* editButton;
@property (nonatomic,strong) UIBarButtonItem* doneButton;
@property (nonatomic, weak) UICollectionViewCell* addTasksCell;

@property (nonatomic, strong) NSArray* taskPrototypeEntities; // Contains KTTaskPrototype objects
@property (nonatomic, strong) NSIndexPath* indexPathForAddTaskCell;

-(void) renumberVisibleTasks;

- (IBAction)startButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

- (KTTask*) taskForIndexPath:(NSIndexPath *)indexPath;

-(void) handleDidDeleteTask:(NSNotification*) notification;
-(BOOL) isIndexPathForAddTaskCell:(NSIndexPath*) indexPath;

-(void) turnEditingOn;
-(void) turnEditingOff;

@end

@implementation KTRoutineInfoController

@synthesize isEditing = _isEditing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _startInEditMode = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.indexPathForAddTaskCell = [NSIndexPath indexPathForRow:0 inSection:0];

    self.taskPrototypeEntities = [[[KTDataAccess sharedInstance] taskQueries] getTaskPrototypes];

    self.collectionView.backgroundColor = [ADVTheme viewBackgroundColor];
    self.collectionView.draggable = YES;
    
    //self.navigationItem.title = self.routineEntity.name;
    
    // Set up the edit/done button
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self
                                                                    action:@selector(turnEditingOn)];
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(turnEditingOff)];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    // Save the left button (from the storyboard) for later
    self.backButton = self.navigationItem.leftBarButtonItem;

    // Set up the multi-image picker
    self.blankSlateEditor = [[KTBlankSlateRoutineEditor alloc] init];
    self.blankSlateEditor.delegate = self;
    
    self.multiImagePicker = [[ELCImagePickerController alloc] initImagePicker];
    self.multiImagePicker.maximumImagesCount = KTImagePickerMaxImages;
    self.multiImagePicker.returnsOriginalImage = KTImagePickerReturnsOriginal;
    self.multiImagePicker.imagePickerDelegate = self.blankSlateEditor;
    
    // Also the camera image picker
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.cameraImagePicker = [[UIImagePickerController alloc] init];
        self.cameraImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraImagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        self.cameraImagePicker.allowsEditing = YES;
        self.cameraImagePicker.delegate = self.blankSlateEditor;
    }
    else {
        self.cameraImagePicker = nil;
    }
    
    // Register for routine CRUD notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDidDeleteTask:)
                                                 name:KTNotificationDidDeleteTask
                                               object:nil];
    
    // Listen for task updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTaskChanged:)
                                                 name:KTNotificationTaskNameDidChange
                                               object:nil];
    
    // Listen for task updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTasksAdded:)
                                                 name:KTNotificationDidAddTasksToRoutine
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.isEditing = self.startInEditMode;
    self.startInEditMode = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification handlers

-(void) handleDidDeleteTask:(NSNotification*) notification {

    NSNumber* deletedTaskDatabaseIndex = [[notification userInfo] objectForKey:KTKeyDeletedObjectIndex];
    NSAssert(deletedTaskDatabaseIndex, @"No deleted task index found on deleted-task notification");
    
    NSInteger deletedTaskCollectionIndex = [deletedTaskDatabaseIndex integerValue] + 1;
    NSIndexPath* deletedTaskCollectionIndexPath = [NSIndexPath indexPathForRow:deletedTaskCollectionIndex inSection:0];
    
    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:deletedTaskCollectionIndexPath]];    
    [self renumberVisibleTasks];
}

-(void) handleTaskChanged:(NSNotification*) notification {
    
    KTTask* changedTask = [[notification userInfo] objectForKey:KTKeyTaskEntity];
    NSAssert(changedTask, @"No task found on change-task notification");
    
    NSIndexPath* taskIndex = [self indexPathForTask:changedTask];
    NSAssert(![self isIndexPathForAddTaskCell:taskIndex], @"Trying to change the add-task cell");
    
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:taskIndex];
    NSAssert([cell isKindOfClass:[KTTaskCell class]],
             @"handleTaskChanged : unexpected cell type; expected KTTaskCell");
    
    KTTaskCell* taskCell = (KTTaskCell*) cell;
    [taskCell prepareForTask:changedTask isEditing:self.isEditing isNew:NO];
}

-(void) handleTasksAdded:(NSNotification*) notification {
    
    NSNumber* numberOfTasksAddedObj = [[notification userInfo] objectForKey:KTKeyNumberOfItems];
    NSAssert(numberOfTasksAddedObj, @"No task count found on routine-tasks-changed notification");
    NSUInteger numberOfTasksAdded = [numberOfTasksAddedObj unsignedIntegerValue];
    
    NSMutableArray* indexPaths = [NSMutableArray arrayWithCapacity:numberOfTasksAdded];
    for (NSUInteger i = 1; i <= numberOfTasksAdded; i++) { // Leave room for add-task cell at front
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
    [self renumberVisibleTasks];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger retval = [self.routineEntity.tasks count] + 1;
    return retval;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    UICollectionViewCell* retval = nil;
    
    if ([self isIndexPathForAddTaskCell:indexPath]) {
        
        KTAddTaskCell* addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addTaskCell" forIndexPath:indexPath];
        addCell.addTaskLabel.text = NSLocalizedString(@"action.task.add", nil);
        
        self.addTasksCell = retval;
        retval = addCell;
    }
    else {
        KTTaskCell* taskCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"taskCell" forIndexPath:indexPath];
        KTTask* task = [self taskForIndexPath:indexPath];
        taskCell.taskEntity = task;
        taskCell.toolbar = self.navigationController.toolbar;

        [taskCell prepareForTask:task isEditing:self.isEditing isNew:NO];
        
        retval = taskCell;
    }
    
    return retval;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *retval = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {

        KTRoutineInfoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"taskListHeader" forIndexPath:indexPath];
        NSString* startText = [NSLocalizedString(@"action.routine.start", nil) uppercaseString];
        [headerView.startRoutineButton setTitle:startText forState:UIControlStateNormal];
 
        [headerView attachToRoutine:self.routineEntity];
        
        retval = headerView;
        self.headerView = headerView; // Save for later

        // Trigger to away the keyboard when not being used any more for routine name editing
        /*
        self.hideKeyboardGestureRecognizer = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self.headerView
                                              action:@selector(putAwayKeyboard)];
        self.hideKeyboardGestureRecognizer.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:self.hideKeyboardGestureRecognizer];
         */
        
        self.headerView.isEditing = self.isEditing;
    }
    
    return retval;
}

-(void) collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    // Clean up the header view
    if ( elementKind == UICollectionElementKindSectionHeader ) {
        self.headerView = nil;
        //[self.view removeGestureRecognizer:self.hideKeyboardGestureRecognizer];
        //self.hideKeyboardGestureRecognizer = nil;
    }
}

#pragma mark - UICollectionViewDataSource_Draggable

- (void)collectionView:(UICollectionView *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath {

    NSAssert(![self isIndexPathForAddTaskCell:fromIndexPath], @"Trying to move from add-task cell");
    NSAssert(![self isIndexPathForAddTaskCell:toIndexPath], @"Trying to move to add-task cell");
    
    // Adjust indices for "add task" button
    [self.routineEntity moveTasksAtPosition:fromIndexPath.row-1 toPosition:toIndexPath.row-1 commit:YES];
    
    // Let other layers know about the update
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationRoutineTasksDidChange
                                                        object:self
                                                      userInfo:[NSDictionary
                                                                dictionaryWithObject:self.routineEntity
                                                                forKey:KTKeyRoutineEntity]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    // Prevent moving the add-task cell
    return ![self isIndexPathForAddTaskCell:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // Prevent moving tasks into the spot for the add-task cell
    return ![self isIndexPathForAddTaskCell:toIndexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self renumberVisibleTasks];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
	if ([segue.identifier isEqualToString:@"routineInfoToTask"]) {
        
        NSAssert([segue.destinationViewController isKindOfClass:[KTTaskDetailController class]],
                 @"routine info -> task info segue going to an unexpected controller type");
		KTTaskDetailController* destinationController = (KTTaskDetailController*) segue.destinationViewController;
        
        if ([sender isKindOfClass:[KTTaskCell class]]) {
            // Called from standard storyboard segue
            KTTaskCell* tappedTaskCell = (KTTaskCell*) sender;
            destinationController.taskEntity = tappedTaskCell.taskEntity;
        }
        else if ([sender isKindOfClass:[KTTask class]]) {
            // Called programatically, such as creating a new task
            destinationController.taskEntity = (KTTask*) sender;
        }
	}
	else if ([segue.identifier isEqualToString:@"routine-to-run-routine"]) {
        // TODO Only run the routine if it has some tasks; otherwise it crashes!
		KTRunRoutineTaskController* destinationController = (KTRunRoutineTaskController*) segue.destinationViewController;
        destinationController.routineEntity = self.routineEntity;
	}
    else if ([segue.identifier isEqualToString:@"routineInfoToAddTasks"]) {
		UINavigationController* navigationController = segue.destinationViewController;
        KTRoutineAddTasksController* addTasksController = (KTRoutineAddTasksController*) [[navigationController viewControllers] objectAtIndex:0];
        addTasksController.routineEntity = self.routineEntity;
    }
    
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // No navigation while editing
    return ! self.isEditing;
}

#pragma mark - Actions

- (IBAction)startButtonPressed:(id)sender {
}

- (IBAction)addButtonPressed:(id)sender {

    NSMutableArray* options = [NSMutableArray array];
    
    // You can pick built-in tasks for non-blank-slate themes
    if (![self.routineEntity.theme isCustomTheme]) {
        [options addObject:KT_ROUTINE_PICK_TASKS];
    }
    
    // You can take a photo if you have a camera
    if (self.cameraImagePicker) {
        [options addObject:KT_ROUTINE_TAKE_PHOTO];
    }
    
    // You can always pick images
    [options addObject:KT_ROUTINE_PICK_IMAGES];

    if ( [options count] == 1 ) {
        // No need for an action sheet in this case
        [self pickPhotos];
    }
    else {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"action.cancel", nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString* option in options) {
            [actionSheet addButtonWithTitle:option];
        }
        
        [actionSheet showFromToolbar:self.navigationController.toolbar];
    }
}


#pragma mark - KTEditable

-(void) setIsEditing:(BOOL)isEditing {
    
    _isEditing = isEditing;
    
    self.addTasksCell.userInteractionEnabled = !isEditing;
    self.addTasksCell.contentView.alpha = (isEditing ? 0.5 : 1.0);
    
    if ( isEditing ) {
        // Show the delete button on each task
        for ( NSIndexPath* taskCellPath in [self.collectionView indexPathsForVisibleItems] ) {
            
            UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:taskCellPath];
            
            if ( [cell isKindOfClass:[KTTaskCell class]] ) {
                KTTaskCell* taskCell = (KTTaskCell*) cell;
                taskCell.isEditing = YES;
            }
        }                
        
        // Update nav bar
        self.navigationItem.rightBarButtonItem = self.doneButton;
        self.navigationItem.hidesBackButton = YES;
        
        // Header view is not loaded when this view first loads
        if ( self.headerView ) {
            self.headerView.isEditing = YES;
        }
    }
    else {
        // Hide the delete button on each task
        for ( NSIndexPath* taskCellPath in [self.collectionView indexPathsForVisibleItems] ) {
            
            UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:taskCellPath];
            
            if ( [cell isKindOfClass:[KTTaskCell class]] ) {
                KTTaskCell* taskCell = (KTTaskCell*) cell;
                taskCell.isEditing = NO;
            }
        }
        
        // Update nav bar
        self.navigationItem.rightBarButtonItem = self.editButton;
        self.navigationItem.hidesBackButton = NO;
        
        // Header view is not loaded when this view first loads
        if ( self.headerView ) {
            self.headerView.isEditing = NO;
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ( buttonIndex != actionSheet.cancelButtonIndex ) {
        
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if ([buttonTitle isEqualToString:KT_ROUTINE_TAKE_PHOTO]) {
            [self takePhoto];
        }
        else if ([buttonTitle isEqualToString:KT_ROUTINE_PICK_IMAGES]) {
            [self pickPhotos];
        }
        else if ([buttonTitle isEqualToString:KT_ROUTINE_PICK_TASKS]) {
            [self performSegueWithIdentifier:@"routineInfoToAddTasks" sender:self];
        }
    }
    
}

#pragma mark - KTEditRoutineDelegate

-(void) didCancelEditingRoutine {
    [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) didInsertTasksAtBeginningOfRoutine:(NSMutableOrderedSet*) insertedTasks {
    
    [self.multiImagePicker dismissViewControllerAnimated:YES completion:^{
        // Animate the task additions after returning to the parent view
        NSNumber* numberOfTasksAdded = [NSNumber numberWithUnsignedInteger:[insertedTasks count]];
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationDidAddTasksToRoutine
                                                            object:self
                                                          userInfo:@{ KTKeyRoutineEntity : self.routineEntity,
                                                                      KTKeyNumberOfItems : numberOfTasksAdded }];
    }];
    
    if (self.cameraImagePicker) {
        [self.cameraImagePicker dismissViewControllerAnimated:YES completion:^{
            // Animate the task additions after returning to the parent view
            NSNumber* numberOfTasksAdded = [NSNumber numberWithUnsignedInteger:[insertedTasks count]];
            [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationDidAddTasksToRoutine
                                                                object:self
                                                              userInfo:@{ KTKeyRoutineEntity : self.routineEntity,
                                                                          KTKeyNumberOfItems : numberOfTasksAdded }];
        }];
    }
}

#pragma mark - Internal helpers

- (void)takePhoto
{
    if ( self.cameraImagePicker ) {
        if ( [KTPhotoAccessChecker vetPhotoAccess] ) {
            self.blankSlateEditor.routineEntity = self.routineEntity;
            [self presentViewController:self.cameraImagePicker animated:YES completion:nil];
        }
    }
    
    /*
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     if (self.popover.isPopoverVisible) {
     [self.popover dismissPopoverAnimated:NO];
     }
     
     self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker;
     [self.popover presentPopoverFromBarButtonItem:self.cameraButton
     permittedArrowDirections:UIPopoverArrowDirectionAny
     animated:YES];
     } else {
     */
}

-(void) pickPhotos {
//    if ( [KTPhotoAccessChecker vetPhotoAccess] ) {
//        self.blankSlateEditor.routineEntity = self.routineEntity;
//        [self presentViewController:self.multiImagePicker animated:YES completion:nil];
//    }
    GMImagePickerController *picker = [[GMImagePickerController alloc] init];
//    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) renumberVisibleTasks {
    
    for ( NSIndexPath* taskCellPath in [self.collectionView indexPathsForVisibleItems] ) {
        
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:taskCellPath];
        
        if ( [cell isKindOfClass:[KTTaskCell class]] ) {
            KTTaskCell* taskCell = (KTTaskCell*) cell;
            [taskCell updateLabelForCurrentPosition];
        }
    }
}

- (KTTask*) taskForIndexPath:(NSIndexPath *)indexPath {
    NSInteger taskIndex = indexPath.row - 1; // Accounting for add-task button at the beginning
	return [self.routineEntity.tasks objectAtIndex:taskIndex];
}

- (NSIndexPath*) indexPathForTask:(KTTask *)task {
    
    NSIndexPath* retval = nil;
    NSUInteger taskArrayIndex = [self.routineEntity.tasks indexOfObject:task];
    
    if ( taskArrayIndex != NSNotFound ) {
        retval = [NSIndexPath indexPathForItem:taskArrayIndex + 1 inSection:0];
    }
    
    return retval;
}

-(BOOL) isIndexPathForAddTaskCell:(NSIndexPath*) indexPath {
    NSComparisonResult result = [self.indexPathForAddTaskCell compare:indexPath];
    return result == NSOrderedSame;
}

-(void) turnEditingOn {
    self.isEditing = YES;
}

-(void) turnEditingOff {
    self.isEditing = NO;
}

@end
