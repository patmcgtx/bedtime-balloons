//
//  KTParentalGateDelegate.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/20/14.
//
//

#import <Foundation/Foundation.h>

@protocol KTParentalGateDelegate <NSObject>

-(void) parentalCheckPassed;
-(void) parentalCheckFailed;

@end
