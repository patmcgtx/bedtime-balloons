//
//  KTTaskNotifiication.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/13/13.
//
//

#import "KTTaskNotifiication.h"

@interface KTTaskNotifiication ()

@property (nonatomic,retain) UILocalNotification* notification;

@end

@implementation KTTaskNotifiication

@synthesize notification = _notification;


- (id)initWithTask:(KTTask*) task {
    
    self = [super init];
    if (self) {
        _notification = nil;
    }
    
    return self;
}

-(void) scheduleForDate:(NSDate*) fireDate {

    [self cancel]; // Only one notification at a time!
    
    self.notification = [[UILocalNotification alloc] init];
    
    self.notification.fireDate = fireDate;
    self.notification.alertBody = NSLocalizedString(@"notification.timer.warning", nil);
    self.notification.soundName = @"warning-long.caf";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
}

-(void) cancel {
    
    if ( self.notification ) {
        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
        self.notification = nil;
    }
}

+(void) cancelAll {
    // Cancels all notifications for this app
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
