//
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/9/14.
//
//

#import <UIKit/UIKit.h>
#import "KTRoutinePlus.h"
#import "UICollectionView+Draggable.h"
#import "KTEditable.h"
#import "KTEditRoutineDelegate.h"

@interface KTRoutineInfoController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDataSource_Draggable, KTEditable, UIActionSheetDelegate, KTEditRoutineDelegate>

@property (nonatomic, strong) KTRoutine* routineEntity;
@property (nonatomic) BOOL startInEditMode;

@end
