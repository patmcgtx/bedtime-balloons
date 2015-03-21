//
//  KTTaskImageEditorController.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/5/14.
//
//

#import <UIKit/UIKit.h>
#import "KTTaskImageEditorDelegate.h"

@interface KTTaskImageEditorController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) id<KTImageEditorDelegate> delegate;

@end
