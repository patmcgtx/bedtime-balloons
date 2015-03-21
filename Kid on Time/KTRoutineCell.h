//
//  KTRoutineCell.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 1/19/14.
//
//

#import <UIKit/UIKit.h>
#import "KTRoutine.h"
#import "KTRoutineCollectionController.h"
#import "KTEditable.h"

@interface KTRoutineCell : UICollectionViewCell <UICollectionViewDataSource, UIActionSheetDelegate, UIGestureRecognizerDelegate, KTEditable>

@property (strong, nonatomic, readonly) KTRoutine* routineEntity;

-(void) prepareForRoutine:(KTRoutine*)routine isEditable:(BOOL) isEditable;

// Actions
- (IBAction)deleteButtonPressed:(id)sender; // TODO -> deleteRoutine

@end
