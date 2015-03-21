//
//  KTTaskCell.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/9/14.
//
//

#import <UIKit/UIKit.h>
#import "KTTaskPlus.h"
#import "KTEditable.h"

@interface KTTaskCell : UICollectionViewCell <UIActionSheetDelegate, UIGestureRecognizerDelegate, KTEditable>

// Injected from calling objects
@property (nonatomic, strong) KTTask* taskEntity;
@property (weak, nonatomic) UIToolbar* toolbar;

-(void) prepareForTask:(KTTask*) updatedTask isEditing:(BOOL) isEditing isNew:(BOOL) isNew;

-(IBAction) deleteTask:(id)sender;

-(void) updateLabelForCurrentPosition;

@end
