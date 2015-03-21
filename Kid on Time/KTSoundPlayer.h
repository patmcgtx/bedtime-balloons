//
//  KTSoundPlayer.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
 * This class plays sounds.  It just follows orders and does not
 * really know anything about the sounds it plays or when to
 * play them.  It is basically a CD player.
 *
 * It is singleton because we should only have one set of sounds
 * playing at a time.
 */
@interface KTSoundPlayer : NSObject <AVAudioPlayerDelegate>

// Singleton
+(KTSoundPlayer*) sharedInstance;

-(void) playPopSound;
-(void) playBalloonCollectSound;
-(void) playTaskCompleteSound;

-(NSTimeInterval) countdownSoundDuration;

-(void) scheduleFirstWarningSoundAt:(NSDate*) playTime;
-(void) scheduleSecondWarningSoundAt:(NSDate*) playTime;
-(void) scheduleCountdownSoundAt:(NSDate*) playTime;

-(void) cancelAllScheduledSounds;

-(void) stopAllSounds;

-(void) mute;
-(void) unmute;

@end
