//
//  KTSoundPlayer.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTSoundPlayer.h"
#import "SimpleAudioEngine.h"
#import "KTErrorReporter.h"
#import "RTSLog.h"

@interface KTSoundPlayer ()

-(AVAudioPlayer*) createAudioPlayerForFile:(NSString*) fileName
                                 extension:(NSString*) fileExtension;

/*
 * Starts a sound looping indefinitely.
 * Tracks the sound in the active list if it "very quick".
 * In this case, "very quick" means a sound that I can always let
 * run to completion and do not ever need to worry about stopping
 * such as when the scene ends.
 *
 * Returns YES if it was able to play the sound, NO otherwise.
 */
-(BOOL) playSound:(AVAudioPlayer*) soundPlayer isVeryQuick:(BOOL) isVeryQuick;

/*
 * Stops a sound from playing.
 * Leaves it in the active list.
 */
-(void) stopSound:(AVAudioPlayer*) soundPlayer;

/*
 * Internal timer helpers
 */
- (void)playTimedCountdownSound:(NSTimer*)theTimer;

// This is to track long-running sounds
@property (nonatomic, retain) NSMutableSet* activeSounds;
@property (nonatomic) BOOL isMuted;

@property (nonatomic, retain) AVAudioPlayer *balloonPopPlayer1;
@property (nonatomic, retain) AVAudioPlayer *balloonPopPlayer2;
@property (nonatomic, retain) AVAudioPlayer *balloonPopPlayer3;
@property (nonatomic, retain) AVAudioPlayer *balloonPopPlayer4;
@property (nonatomic, retain) AVAudioPlayer *balloonCollectPlayer;
@property (nonatomic, retain) AVAudioPlayer *taskCompletePlayer;

@property (nonatomic, retain) AVAudioPlayer *warning1Player;
@property (nonatomic, retain) AVAudioPlayer *warning2Player;
@property (nonatomic, retain) AVAudioPlayer *countdownPlayer;

@property (nonatomic, retain) NSTimer* warning1Timer;
@property (nonatomic, retain) NSTimer* warning2Timer;
@property (nonatomic, retain) NSTimer* countdownTimer;

@end

@implementation KTSoundPlayer

@synthesize isMuted = _isMuted;
@synthesize balloonCollectPlayer = _balloonCollectPlayer;
@synthesize balloonPopPlayer1 = _balloonPopPlayer1;
@synthesize balloonPopPlayer2 = _balloonPopPlayer2;
@synthesize balloonPopPlayer3 = _balloonPopPlayer3;
@synthesize balloonPopPlayer4 = _balloonPopPlayer4;
@synthesize taskCompletePlayer = _taskCompletePlayer;

@synthesize warning1Player = _warning1Player;
@synthesize warning2Player = _warning2Player;
@synthesize countdownPlayer = _countdownPlayer;

@synthesize warning1Timer = _warning1Timer;
@synthesize warning2Timer = _warning2Timer;
@synthesize countdownTimer = _countdownTimer;

- (id)init
{
    self = [super init];
    if (self) {
        
        _activeSounds = [NSMutableSet setWithCapacity:10]; // 10 is a guess at optimal capacity, but it can hold more as neeed.
        
        _isMuted = NO;
        
        //
        // Audio session
        //        
        NSError* error2 = nil;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient
                                               error: &error2];
        if ( error2 ) {
            [[KTErrorReporter sharedReporter] warnUserWithMessageKey:@"Internal audio error"
                                                               error:error2
                                                           debugInfo:@"sound player : init : failed to set category"];
        }
        
        NSError *error1 = nil;
        [[AVAudioSession sharedInstance] setActive: YES error: &error1];
        if ( error1 ) {
            [[KTErrorReporter sharedReporter] warnUserWithMessageKey:@"Internal audio error"
                                                               error:error1
                                                           debugInfo:@"sound player : init : failt to set active"];
        }
        
        //
        // Init the sounds
        //
        
        // The baseline volume is about 0.5 (half).  Otherwise, it plays really loud!
        
        // The balloon pop player is a special case.  It is possible to pop one balloon after
        // the other before the previous pop sound has finished.  In that case, the second pop
        // sound is skipped because the sound play is already playing.  So we have to fall back
        // to a backup player #2, and even a #3 and #4 if necessary.
        _balloonPopPlayer1 = [self createAudioPlayerForFile:@"balloon-pop-hd" extension:@"wav"];
        _balloonPopPlayer1.volume = 1.0;
        [_balloonPopPlayer1 prepareToPlay];

        _balloonPopPlayer2 = [self createAudioPlayerForFile:@"balloon-pop-hd" extension:@"wav"];
        _balloonPopPlayer2.volume = 1.0;
        [_balloonPopPlayer2 prepareToPlay];

        _balloonPopPlayer3 = [self createAudioPlayerForFile:@"balloon-pop-hd" extension:@"wav"];
        _balloonPopPlayer3.volume = 1.0;
        [_balloonPopPlayer3 prepareToPlay];
        
        _balloonPopPlayer4 = [self createAudioPlayerForFile:@"balloon-pop-hd" extension:@"wav"];
        _balloonPopPlayer4.volume = 1.0;
        [_balloonPopPlayer4 prepareToPlay];

        
        _balloonCollectPlayer = [self createAudioPlayerForFile:@"Achieved" extension:@"caf"];
        _balloonCollectPlayer.volume = 0.65;
        [_balloonCollectPlayer prepareToPlay];
        
        _taskCompletePlayer = [self createAudioPlayerForFile:@"complete" extension:@"caf"];
        _taskCompletePlayer.volume = 0.65;
        [_taskCompletePlayer prepareToPlay];
        
        _countdownPlayer = [self createAudioPlayerForFile:@"countdown" extension:@"caf"];
        _countdownPlayer.volume = 1.0;
        
        _warning1Player = [self createAudioPlayerForFile:@"warning-short" extension:@"caf"];
        _warning1Player.volume = 1.0;

        _warning2Player = [self createAudioPlayerForFile:@"warning-long" extension:@"caf"];
        _warning2Player.volume = 1.0;
    }
    return self;
}

-(NSTimeInterval) countdownSoundDuration {
    return self.countdownPlayer.duration;
}

#pragma mark - Global controls

-(void) mute {
    self.isMuted = YES;
}

-(void) unmute {
    self.isMuted = NO;
}

// This doesn't just pause the sounds, it actually kills them
// and removes them from the active list.
-(void) stopAllSounds {
    
    for ( AVAudioPlayer* soundPlayer in self.activeSounds ) {
        [self stopSound:soundPlayer];
    }
    
    // We had to be sure not to remove the sounds one at a time
    // while iterating the active list.  That causes a core!
    [self.activeSounds removeAllObjects];
}

#pragma mark - Basic sounds

-(void) playPopSound {
    
    // See notes in -init on why we need multiple possible pop players.
    // Basically, it comes down to playing them all at once if balloons
    // are popped really quickly together.
    if ( ! [self playSound:self.balloonPopPlayer1 isVeryQuick:YES] ) {
        if ( ! [self playSound:self.balloonPopPlayer2 isVeryQuick:YES] ) {
            if ( ! [self playSound:self.balloonPopPlayer3 isVeryQuick:YES] ) {
                [self playSound:self.balloonPopPlayer4 isVeryQuick:YES];
            }
        }
    }
}

-(void) playBalloonCollectSound {
    [self playSound:self.balloonCollectPlayer isVeryQuick:YES];
}

-(void) playTaskCompleteSound {
    [self playSound:self.taskCompletePlayer isVeryQuick:YES];
}

#pragma mark - Scheduled sounds

-(void) scheduleFirstWarningSoundAt:(NSDate*) playTime {
    
    [self.warning1Timer invalidate];
    
    self.warning1Timer = [[NSTimer alloc] initWithFireDate:playTime
                                                  interval:0.0
                                                    target:self
                                                  selector:@selector(playTimedFirstWarningSound:)
                                                  userInfo:nil
                                                   repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:self.warning1Timer forMode:NSDefaultRunLoopMode];
}

-(void) scheduleSecondWarningSoundAt:(NSDate*) playTime {
    
    [self.warning2Timer invalidate];
    
    self.warning2Timer = [[NSTimer alloc] initWithFireDate:playTime
                                                  interval:0.0
                                                    target:self
                                                  selector:@selector(playTimedSecondWarningSound:)
                                                  userInfo:nil
                                                   repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:self.warning2Timer forMode:NSDefaultRunLoopMode];
}

-(void) scheduleCountdownSoundAt:(NSDate*) playTime {
    
    [self.countdownTimer invalidate];
    
    self.countdownTimer = [[NSTimer alloc] initWithFireDate:playTime
                                                   interval:0.0
                                                     target:self
                                                   selector:@selector(playTimedCountdownSound:)
                                                   userInfo:nil
                                                    repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSDefaultRunLoopMode];
}

-(void) cancelAllScheduledSounds {
    [self.warning1Timer invalidate];
    [self.warning2Timer invalidate];
    [self.countdownTimer invalidate];
}

#pragma mark - Scheduled sound helpers

- (void)playTimedFirstWarningSound:(NSTimer*)theTimer {
    [self playSound:self.warning1Player isVeryQuick:NO];
}

- (void)playTimedSecondWarningSound:(NSTimer*)theTimer {
    [self playSound:self.warning2Player isVeryQuick:NO];
}

- (void)playTimedCountdownSound:(NSTimer*)theTimer {
    [self playSound:self.countdownPlayer isVeryQuick:NO];
}

#pragma mark - Internal helpers

-(void) moveSoundToRandomSpot:(AVAudioPlayer*) soundPlayer {
    // This is not a very advanced or truly random function, but it is supposed
    // to be quicker than arc4random() or arc4random_uniform().  Should be good
    // enough for me!
    float randTime = random() % (long) soundPlayer.duration;
    soundPlayer.currentTime = randTime;
}


-(AVAudioPlayer*) createAudioPlayerForFile:(NSString*) fileName
                                 extension:(NSString*) fileExtension {
    
    NSString *path =
    [[NSBundle mainBundle] pathForResource: fileName
                                    ofType: fileExtension];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
    
    NSError* error = nil;
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                                                   error: &error];
    if ( error ) {
        [[KTErrorReporter sharedReporter] warnUserWithMessageKey:@"Internal Audio Error"
                                                           error:error
                                                       debugInfo:
         [NSString stringWithFormat:@"sound player : failed to create audio player for : %@", url]];
    }
    
    player.delegate = self;
    
    return player;
}

-(BOOL) playSound:(AVAudioPlayer*) soundPlayer isVeryQuick:(BOOL) isVeryQuick {

    BOOL retval = NO;
    
    if ( ! self.isMuted && ! soundPlayer.isPlaying ) {
        
        soundPlayer.currentTime = 0.0; // Always play from beginning
        retval = [soundPlayer play];
        
        if ( retval && !isVeryQuick ) {
            [self.activeSounds addObject:soundPlayer];
        }
    }
        
    return retval;
}

-(void) stopSound:(AVAudioPlayer*) soundPlayer {
    
    // Don't care about mute state in this method, would
    // stop the sound regardless.
    
    if ( soundPlayer.isPlaying ) {
        [soundPlayer stop];
    }
    
    // Don't remove the sound from the active list.
    // If we do, it causes a core on -stopAllSounds!
    // That is why this was changed to 'pause'.
    // The sound is still around, just not actively playing.
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [[KTErrorReporter sharedReporter] warnUserWithMessageKey:@"AUDIO_PLAY_ERROR"
                                                       error:error
                                                   debugInfo:
     [NSString stringWithFormat:@"sound player : audioPlayerDecodeErrorDidOccur"]];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    LOG_TRACE(@"audioPlayerBeginInterruption : %@", [player description]);
    [self stopSound:player];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    LOG_TRACE(@"audioPlayerEndInterruption : %@", [player description]);
    // Don't think it necesarily make sense to automatically restart any sounds
    // after taking a phone call, etc.
    //[self playSound:player atRandomSpot:YES];
}


#pragma mark Singleton

//
// Single implementation, from:
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//

static KTSoundPlayer* sSharedInstance = nil;


+(KTSoundPlayer*) sharedInstance
{
    if (sSharedInstance == nil) {
        sSharedInstance = [[super allocWithZone:NULL] init];
    }
    return sSharedInstance;
}


+(id) allocWithZone:(NSZone*) zone
{
    return [self sharedInstance];
}


-(id) copyWithZone:(NSZone*) zone
{
    return self;
}

@end

