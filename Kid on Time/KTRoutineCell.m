//
//  KTRoutineCell.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 1/19/14.
//
//

#import "KTRoutineCell.h"
#import "ADVTheme.h"
#import "KTTaskPlus.h"
#import "KTTaskBasePlus.h"
#import "KTRoutineTaskPreviewCell.h"
#import "KTConstants.h"
#import "KTDataAccess.h"
#import "KTRoutinePlus.h"

@interface KTRoutineCell ()

@property (weak, nonatomic) IBOutlet UILabel* routineNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *taskCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) UILongPressGestureRecognizer* gestureRecognizer;

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender;

@end

@implementation KTRoutineCell

@synthesize isEditing = _isEditing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // This allows us to hide the delete button while moving the task cell
        self.gestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(handleLongPressGesture:)];
        self.gestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.gestureRecognizer];
    }
    return self;
}

-(void) prepareForReuse {

    [super prepareForReuse];

    _routineEntity = nil;
    
    self.routineNameLabel.text = @"";
    self.deleteButton.hidden = YES;
}

-(void) prepareForRoutine:(KTRoutine*)routine isEditable:(BOOL) isEditable {

    _routineEntity = routine;
    self.routineNameLabel.text = routine.name;
    [self.taskCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    self.isEditing = isEditable;
}

#pragma mark - KTEditable

-(void) setIsEditing:(BOOL)isEditing {
    
    _isEditing = isEditing;

    if ( isEditing ) {
        self.deleteButton.alpha = 0.0;
        self.deleteButton.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        self.deleteButton.alpha = 1.0;
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.deleteButton.hidden = YES;
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUInteger numTasks = [self.routineEntity.tasks count];
    return ( numTasks > 6 ? 6 : numTasks ); // Limit to 6 since that's all that will be seen anyways
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KTRoutineTaskPreviewCell* cell = [collectionView
                                      dequeueReusableCellWithReuseIdentifier:@"RoutineTaskCell" forIndexPath:indexPath];
    
    // We should not get anything beyond the lenght of the tasks list, but just in case...
    if ( indexPath.row < [self.routineEntity.tasks count] ) {
        KTTask* task = [self.routineEntity.tasks objectAtIndex:indexPath.row];        
        [cell updateForTask:task];
    }
    
    return cell;
}

#pragma mark - Actions

- (IBAction)deleteButtonPressed:(id)sender {

    NSString* title = nil;
    if ( self.routineEntity.name && [self.routineEntity.name length] > 0 ) {
        title = [NSString stringWithFormat:NSLocalizedString(@"label.delete.question", nil), self.routineEntity.name];
    }
    
    // Confirm
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"action.cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"action.delete", nil)
                                                    otherButtonTitles:nil];

    // No direct link from here to whatever view controller is presenting the action sheet.
    // It could be different on iPhone vs. iPad, etc.  We just have to hope someone runs
    // with this notification. :-)
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationDoPresentActionSheet
                                                        object:self
                                                      userInfo:[NSDictionary
                                                                dictionaryWithObject:actionSheet
                                                                forKey:KTKeyActionSheet]];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == actionSheet.destructiveButtonIndex ) {
        
        [KTRoutine deleteRoutine:self.routineEntity commit:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationDidDeleteRoutine
                                                            object:self
                                                          userInfo:[NSDictionary
                                                                    dictionaryWithObject:self.routineEntity
                                                                    forKey:KTKeyRoutineEntity]];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // Allow this object to handle the long press while also allowing the DraggableCollectionView stuff to work
    return YES;
}

#pragma mark - Misc

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    // Hide the delete button while moving/dragging to avoid unseemly image cropping
    //self.deleteButton.hidden = YES;
}

@end
