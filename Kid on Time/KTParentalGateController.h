//
//  KTParentalGateController.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/20/14.
//
//

#import <UIKit/UIKit.h>
#import "KTParentalGateDelegate.h"

@interface KTParentalGateController : UIViewController

@property (nonatomic, weak) id<KTParentalGateDelegate> delegate;
@property (nonatomic, strong) NSString* purpose;

@end
