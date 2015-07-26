//
//  KTRoutineTaskPreviewCell.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 1/19/14.
//
//

#import <UIKit/UIKit.h>
#import "KTTask.h"

@interface KTRoutineTaskPreviewCell : UICollectionViewCell

@property (strong, nonatomic) KTTask* taskEntity;
@property (nonatomic) BOOL isWaitingForDownload;

-(void) updateForTask:(KTTask*) taskEntity;

@end
