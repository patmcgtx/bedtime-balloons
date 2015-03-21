//
//  KTRoutineCollectionDataSource.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/2/14.
//
//

#import <Foundation/Foundation.h>
#import "UICollectionView+Draggable.h"
#import "KTEditable.h"

@interface KTRoutineCollectionDataSource : NSObject
<UICollectionViewDataSource, UICollectionViewDataSource_Draggable>

@property (nonatomic, weak) UICollectionViewCell* addRoutinesCell;

- (instancetype)initForPresentingElement:(id<KTEditable>) presenting
                          collectionView:(UICollectionView*) collectView;

@end
