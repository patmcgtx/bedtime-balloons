//
//  KTRoutineAnimationsLayer.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/19/13.
//
//

#import "KTRoutineAnimationsLayer.h"
#import "RTSLog.h"
#import "KTTimer.h"
#import "KTVillain.h"
#import "KTBalloon.h"
#import "KTPointCount.h"
#import "KTTask.h"
#import "KTRoutinePlus.h"
#import "KTConstants.h"
#import "KTResultDrawing.h"
#import "KTRoutineGrade.h"
#import "KTChalkboardPointCount.h"
#import "RTSAppHelper.h"
#import "KTCocos2dEngine.h"
#import "KTUserPoppableBalloon.h"
#import "KTInvisibleCloseButton.h"
#import "KTSoundPlayer.h"

@interface KTBalloonCoordAndStyle : NSObject

- (id)initWithCoord:(CGPoint) coord style:(KTBalloonStyle) style;

@property (nonatomic) CGPoint coord;
@property (nonatomic) KTBalloonStyle style;

@end

@implementation KTBalloonCoordAndStyle

@synthesize coord = _coord;
@synthesize style = _style;

- (id)initWithCoord:(CGPoint) coord style:(KTBalloonStyle) style
{
    self = [super init];
    if (self) {
        _coord = coord;
        _style = style;
    }
    return self;
}

@end


@interface KTRoutineAnimationsLayer ()

@property (strong, nonatomic) KTTimer* timer;
@property (strong, nonatomic) KTPointCount* pointCount;
@property (strong, nonatomic) NSMutableArray* taskStartSequences;
@property (strong, nonatomic) KTRoutine* routineEntity;
@property (strong, nonatomic) KTVillain* villain;
@property (strong, nonatomic) KTBalloon* balloon1;
@property (strong, nonatomic) KTBalloon* balloon2;
@property (strong, nonatomic) KTBalloon* balloon3;
@property (strong, nonatomic) KTBalloon* balloon4;
@property (strong, nonatomic) KTBalloon* balloon5;
@property (strong, nonatomic) KTBalloon* balloon6;
@property (strong, nonatomic) KTInvisibleCloseButton* invisibleCloseButton;
@property (strong, nonatomic) NSMutableArray* rewardBalloons;
//@property (strong, nonatomic) CCSpeed* runningTaskSequence;

//-(CCSequence*) buildAnimationsForTask:(int) taskTimeInSeconds;
//-(CCSequence*) buildAnimationsToWrapUpTask:(BOOL) isLastTask;
-(int) routinePerformancePercentage;
-(KTRoutineGrade) routinePerformanceResult;
-(int) numBalloonsEarned;
-(NSArray*) rewardBalloonInfo;
//-(void) revertRunningTaskToNormalTime;
//-(void) resetCurentTaskToTime:(NSTimeInterval) newTimeInSeconds
//             timeInBackground:(NSTimeInterval) durationInBg;

@end

@implementation KTRoutineAnimationsLayer

-(id) init
{
    if( (self=[super init]) ) {
        
        // This doesn't do anything useful until
        // _cocos2dView userInteractionEnabled is set to YES
        self.touchEnabled = YES;
        
        // Wil set this later when needed
        self.rewardBalloons = nil;
        
//        _runningTaskSequence = nil;
    }
    
	return self;
}

-(void) loadRoutine:(KTRoutine*) routine {
    
    self.routineEntity = routine;
    
    //
    // Add villain
    //
    _villain = [[KTVillain alloc] initForLayer:self];
    
    // Will use this as a reference point for sprite layout
    CGRect screenBounds = [[RTSAppHelper sharedInstance] windowBoundsForLandscape:YES
                                                                       forCocos2d:NO];
    CGFloat midpointHoriz = screenBounds.size.width / 2.0;
    
    //
    // Add balloons with a slightly non-uniform layout
    // to make it more dynamic or interesting looking.
    //
    _balloon1 = [[KTBalloon alloc] initForLayer:self
                                   withPosition:ccp(midpointHoriz - 110, 290)
                                          style:kKTBalloonStyleRed forReward:NO];
    _balloon2 = [[KTBalloon alloc] initForLayer:self
                                   withPosition:ccp(midpointHoriz - 66, 292)
                                          style:kKTBalloonStyleBlue forReward:NO];
    _balloon3 = [[KTBalloon alloc] initForLayer:self
                                   withPosition:ccp(midpointHoriz - 24, 288)
                                          style:kKTBalloonStyleYellow forReward:NO];
    _balloon4 = [[KTBalloon alloc] initForLayer:self
                                   withPosition:ccp(midpointHoriz + 21, 290)
                                          style:kKTBalloonStyleBlue forReward:NO];
    _balloon5 = [[KTBalloon alloc] initForLayer:self
                                   withPosition:ccp(midpointHoriz + 68, 288)
                                          style:kKTBalloonStyleRed forReward:NO];
    _balloon6 = [[KTBalloon alloc] initForLayer:self
                                   withPosition:ccp(midpointHoriz + 104, 292)
                                          style:kKTBalloonStyleYellow forReward:NO];
    
    //
    // Add timer
    // Note that KTRunRoutineTaskController -presentNextTask will actually start the timer
    // TODO Release _timer on dealloc or whatever!
    _timer = [[KTTimer alloc] initForLayer:self
                              withPosition:ccp(28, 170)];
    
    //
    // Add point counter
    //
    // TODO Move point counting to a separate module apart form cocos2d animations!
    _pointCount = [[KTPointCount alloc] initForLayer:self];
    
    //
    // And pre-build all the animation routines so we don't have to build
    // them on the fly, ie when the task done button is pressed, which
    // has proven to be annoying slow and unresponsive.
    //
    /*
    self.taskStartSequences = [NSMutableArray arrayWithCapacity:[routine.tasks count]];
    NSUInteger i = 0;
    
    for ( KTTask* task in routine.tasks ) {
        
        int taskTime = [task.timeInSeconds intValue];
        CCSequence* startSeq = [self buildAnimationsForTask:taskTime];
        [self.taskStartSequences insertObject:startSeq atIndex:i];
        
        i++;
    }
    */
    
    // Add the invisible close button for KIDSCHED-227 :-/
    CGPoint closeBtnCenter = [self.delegate closeButtonCenter];
    CGPoint cocosPos = [[CCDirector sharedDirector] convertToGL: closeBtnCenter]; // Convert to cocos2d coordinates
    self.invisibleCloseButton = [[KTInvisibleCloseButton alloc]
                                 initForLayer:self
                                 atPos:cocosPos
                                 atZPos:200
                                 delegate:self.delegate];
    
}

#pragma mark - Main actions

-(void) startTask:(KTTask*) task {

    //
    // These resets are necessary to keep thing nice and clean on each task
    // execution.  It keeps stray actions and sprite states from carrying over
    // from the previous task ot the next one.  This is necessary since we
    // do not know exactly when the previous task was stopped, and we cannot
    // guarantee the state of any of the sprites.
    // BTW, yes, this is redundant on the first task.  But it keeps things simple
    // at the cost of a tiny bit of inefficiency, but I don't think anyone will notice. :-)
    //
    [_villain resetSprite];
    [_balloon1 resetSprite];
    [_balloon2 resetSprite];
    [_balloon3 resetSprite];
    [_balloon4 resetSprite];
    [_balloon5 resetSprite];
    [_balloon6 resetSprite];

    CCTargetedAction* showBalloon1 = [self.balloon1 appearWithDelay:0.15];
    CCTargetedAction* showBalloon2 = [self.balloon2 appearWithDelay:0.25];
    CCTargetedAction* showBalloon3 = [self.balloon3 appearWithDelay:0.5];
    CCTargetedAction* showBalloon4 = [self.balloon4 appearWithDelay:0.1];
    CCTargetedAction* showBalloon5 = [self.balloon5 appearWithDelay:0.2];
    CCTargetedAction* showBalloon6 = [self.balloon6 appearWithDelay:0.3];
    
    // This kicks off all the balloon inflations at the same time
    // (with the built-in delay mentioed above)
    CCSpawn* showAllBalloons = [CCSpawn actions:showBalloon1, showBalloon2,
                          showBalloon3, showBalloon4,
                          showBalloon5, showBalloon6, nil];
    
    CCTargetedAction* villainHide = [self.villain hideOffScreenWithDuration:0.0];
    
    CCSequence* seq = [CCSequence actions: villainHide,
                       showAllBalloons, nil];
    
    [self runAction:seq];
    
    //CCSequence* seq = [self.taskStartSequences objectAtIndex:taskIndex];
    
    // Wrap the task sequence in a speed and save it so that we can
    // "fast forward" it later to catch up if/when we come back from bg
//    self.runningTaskSequence = [CCSpeed actionWithAction:seq speed:1.0];
    
//    [self runAction:self.runningTaskSequence];
    
    // Now that the villain routine is *started* (async), reset the timer too.
    //    [self.textTimer restartForTime:taskTimeInSeconds];
    [self.timer resetToSeconds:[[task timeInSeconds] intValue]];
}

-(void) startVillainVisit {    
    CCTargetedAction* buzz = [self.villain buzzRandomCorner];
    [self runAction:buzz];
}

-(NSTimeInterval) durationOfVillainVisits {
    return 10.0; // TODO
}

-(void) startPoppingBalloons {
    
    //
    // Note that this cocos2d layer dones't know or need to know anything about
    // the task being presented (take bath, brush teeth, etc.) except for
    // the task's time limit (taskTimeInSeconds).  Nor does it
    // know anythign about the routine's theme.  This cocos2d layer is simply
    // run "on top" of the task illustration and is the same for all tasks
    // and themes.  Keeps it nice and (relatively) simple.
    //
    
    //
    // Now build-up the whole routine of the villain waiting around and then
    // eventually going after the balloons.  We are only creating the actions
    // first, and then piecing them together and running a sort of a multi-sprite
    // routine at the end.
    //
    
    // Villain starts out hidden away
    // This method implicitly assumes the villain was out of site when called.
    // This action just makes sure he is hidden in the right position.
    CCTargetedAction* villainHide = [self.villain hideOffScreenWithDuration:0.0];
        
    // We want the villain facing towards the target balloons
    CCTargetedAction* faceRight = [self.villain faceRight];
    
    // Villain comes out of hiding and is ready to start popping balloons!
    CCTargetedAction* villainGoFirstPosition = [self.villain moveToPosition:ccp(60, 290)
                                                           withDuration:1.5
                                                              easeStart:NO
                                                                easeEnd:YES];
    
    // This is the villain's little loop before actually popping
    // a balloon.  It works on relative positions and can be reused
    // for ech balloon without modification.
    CCTargetedAction* villainLoop = [self.villain windUp];
    
    // TODO Ballloon1 .. Balloon6 could really go into an array to make this simpler...
    
    //
    // Popping a ballons works like this:
    // 1. Villain moves to the target balloon
    // 2. Then these happen simultaneously:
    //  a. Balloon pops itself
    //  b. Villain stars wind-up for next balloon
    //
    
    CCTargetedAction* villainGoToBalloon1 = [self.villain moveToBalloon:self.balloon1
                                        withDuration:0.25];
    CCTargetedAction* popBalloon1 = [self.balloon1 pop];
    CCTargetedAction* popAndLoop1 = [CCSpawn actions:popBalloon1, villainLoop, nil];
    
    CCTargetedAction* villainGoToBalloon2 = [self.villain moveToBalloon:self.balloon2
                                        withDuration:0.25];
    CCTargetedAction* popBalloon2 = [self.balloon2 pop];
    CCTargetedAction* popAndLoop2 = [CCSpawn actions:popBalloon2, villainLoop, nil];
    
    CCTargetedAction* villainGoToBalloon3 = [self.villain moveToBalloon:self.balloon3
                                        withDuration:0.25];
    CCTargetedAction* popBalloon3 = [self.balloon3 pop];
    CCTargetedAction* popAndLoop3 = [CCSpawn actions:popBalloon3, villainLoop, nil];
    
    CCTargetedAction* villainGoToBalloon4 = [self.villain moveToBalloon:self.balloon4
                                        withDuration:0.25];
    CCTargetedAction* popBalloon4 = [self.balloon4 pop];
    CCTargetedAction* popAndLoop4 = [CCSpawn actions:popBalloon4, villainLoop, nil];
    
    CCTargetedAction* villainGoToBalloon5 = [self.villain moveToBalloon:self.balloon5
                                        withDuration:0.25];
    CCTargetedAction* popBalloon5 = [self.balloon5 pop];
    CCTargetedAction* popAndLoop5 = [CCSpawn actions:popBalloon5, villainLoop, nil];
    
    CCTargetedAction* villainGoToBalloon6 = [self.villain moveToBalloon:self.balloon6
                                        withDuration:0.25];
    CCTargetedAction* popBalloon6 = [self.balloon6 pop];
    CCTargetedAction* popAndLoop6 = [CCSpawn actions:popBalloon6, villainLoop, nil];
    
    // Then the villain goes back to hiding
    CCTargetedAction* goAway = [self.villain moveOffScreenAndHide];
    
    // And finally tell the delegate the popping is over
    /*
    CCCallBlock* donePopping = [CCCallBlock actionWithBlock:(^{
        [self.delegate donePoppingBalloons];
    })];
     */
    
    //
    // Finally, this is where it all comes together.
    //
    CCSequence* seq = [CCSequence actions: villainHide,
                       faceRight, villainGoFirstPosition,
                       villainLoop, villainLoop, villainGoToBalloon1, popAndLoop1,
                       villainLoop, villainGoToBalloon2, popAndLoop2,
                       villainLoop, villainGoToBalloon3, popAndLoop3,
                       villainLoop, villainGoToBalloon4, popAndLoop4,
                       villainLoop, villainGoToBalloon5, popAndLoop5,
                       villainLoop, villainGoToBalloon6, popAndLoop6,
                       goAway,
                       //donePopping,
                       nil];
    
    [self runAction:seq];
}

-(void) startCollectingBalloons {

    //
    // Stop the timer.  Otherwise, it keeps going down while
    // the villain and balloons wrap it up!
    //
    [self.timer stop];
    
    //
    // Cancel the villain ballooon popping routine.
    //
    // It is key to stop all actions on the whole layer.
    // Otherwise, all the sprites, esp. the villain, keep going.
    // They even keep going after you stop all actions on the sprite itself.
    // I think this is because of the all the complex actions like
    // CCTargetedAction and CCSequence.
    //
    [self stopAllActions];

    //
    // Now that everything is stopped, do the task wrap-up routine.
    //
    CCTargetedAction* awayWithVillain = [_villain moveOffScreenAndHide];
    
    //
    // Release the balloons (simultaneously)
    //
    CCTargetedAction* b1 = [_balloon1 maybeCashInTowardsPointCount:self.pointCount delay:0.4];
    CCTargetedAction* b2 = [_balloon2 maybeCashInTowardsPointCount:self.pointCount delay:0.15];
    CCTargetedAction* b3 = [_balloon3 maybeCashInTowardsPointCount:self.pointCount delay:0.25];
    CCTargetedAction* b4 = [_balloon4 maybeCashInTowardsPointCount:self.pointCount delay:0.45];
    CCTargetedAction* b5 = [_balloon5 maybeCashInTowardsPointCount:self.pointCount delay:0.1];
    CCTargetedAction* b6 = [_balloon6 maybeCashInTowardsPointCount:self.pointCount delay:0.3];
    
    CCSpawn* simultaneousScatter = [CCSpawn actions:awayWithVillain,
                                    b1, b2, b3, b4, b5, b6,
                                    //showPointCounter,
                                    nil];
    
    //
    // This is going to run at the end of the task wrap-up routine,
    // thanks to the sequence below.  We have to do this as a sequence
    // and callback to the delegate because all cocos2d actions are
    // run asynchronously.  Without this sequence/callback, the
    // controller starts the next task while this wrap-up is still
    // running, resulting in all sorts of ugliness.  Basically, the
    // previous task is still wrapping up while the new one is
    // already started.  This sequence/callback handles it!
    // (The delegate is the containing routine controller.)
    CCCallBlock* doneCollecting = [CCCallBlock actionWithBlock:(^{
        [self.delegate doneCollectingBalloons];
    })];
    
    // The idea is to wait x seconds for all the post-task wrap-up
    // to finish before allowing the next task to start.  Right now,
    // it is just an estimated timer.
    //
    // I actually got it working where the longest-running balloon
    // would call back to the delegate (controller) when it had updated
    // the score, meaning the whole end-task bit was done.  it worked
    // great!  The only problem... Sometimes balloons get popped and
    // never update the score and never call back!  Sometimes all
    // the balloons popped.  So we can't even use the idea of balloon
    // completing the score update as a trigger for the next task to
    // start.  I'm sure it could be worked out somehow, but it would
    // ~greatly~ complicate the code.  So I just stick a little delay
    // in here to let all the balloons do their thing (or not!).
    CCSequence* seq = [CCSequence actions:simultaneousScatter, // Kick off everything at the same time
                       [CCDelayTime actionWithDuration:0.25], // Wait for them to finish
                       doneCollecting, // Tell the contoller to start up the next task
                       nil]; // Go to next task
    
    [self runAction:seq];
}

-(void) startPresentingRewards {
    
    // Hide some controls that are no longer applicable
    [self hideTimeLimitControls];
    
    // Show the percent of ballons earned
    [self.pointCount displayPercentageScore:[self routinePerformancePercentage]];
    
    [self.delegate finishedWithResultRatio:[self routinePerformanceRatio]];
    
    // Prapare a chalk "drawing" on the chalkboard representing the final score
    KTResultDrawing* drawing = [[KTResultDrawing alloc] initWithGrade:[self routinePerformanceResult]
                                                             ForLayer:self];
    // Calculate how many balloons were earned
    int numBalloons = [self numBalloonsEarned];
    
    // Get together the locations of all possible reward balloons
    NSArray* rewardInfo = [self rewardBalloonInfo];
    
    // Check for bad error code; debug only
    NSAssert(numBalloons <= [rewardInfo count],
             @"More reward balloons than balloons!");
    
    self.rewardBalloons = [NSMutableArray arrayWithCapacity:numBalloons];
    
    // This +40 part is a hack... See KTBalloon maybeCashInTowardsPointCount too.
    // The basic idea is to start on the balloon icon on the lower right.
    // TODO Really need a better approach.  Get a ref to the actual ballon icon
    // from the main iOS controller, maybe via the dfelegate, like I do with the
    // cancel button.
    CGPoint balloonStartingPos = ccp(self.pointCount.position.x+40, self.pointCount.position.y);
    
    NSMutableArray* balloonMoves = [NSMutableArray arrayWithCapacity:numBalloons];
    ccTime waitingTime = 0.5;
    
    // Now collect all earned ballons
    for (int i=0; i<numBalloons; i++) {
        
        KTBalloonCoordAndStyle* val = [rewardInfo objectAtIndex:i];
        
        KTUserPoppableBalloon* balloon = [[KTUserPoppableBalloon alloc]
                                          initForLayer:self
                                          withStartingPosition:balloonStartingPos
                                          withFinalPosition:val.coord
                                          style:val.style
                                          bigSize:NO];
        [self.rewardBalloons addObject:balloon];
        
        CCTargetedAction* move = [balloon appearAndMoveIntoFinalPositionWithDelay:waitingTime];
        
        [balloonMoves addObject:move];
        waitingTime += 0.5;
    }
    
    // Kick off the first animation
    // Skip this for custom routines
    if ( ! [self.delegate isCustomRoutine] ) {
        [self runAction:[drawing showWithDelay:0.5]];
    }
    
    // And finally push each one into the screen with a slight delay between each
    CCSpawn* simultaneousBalloobMoves = [CCSpawn actionWithArray:balloonMoves];
    //CCSequence* simultaneousBalloobMoves = [CCSequence actionWithArray:balloonMoves];
    [self runAction:simultaneousBalloobMoves];    
}

-(void) hideTimeLimitControls {
    [self.timer hide];
}

-(void) showTimeLimitControls {
    [self.timer show];
}

#pragma mark - Lifecycle management

- (void) goToBackground {
    
    [[CCDirector sharedDirector] pause];
    // TODO Use [[KTCocos2dEngine sharedInstance] pause]; instead?
}

- (void) restoreToForegroundWithTime:(NSTimeInterval) newTimeInSeconds
                    timeInBackground:(NSTimeInterval) durationInBg {
    
    [[CCDirector sharedDirector] resume];
    
    // And reset the timer with special logic
    [self.timer resetToSecondsLeft:newTimeInSeconds];
}

#pragma mark - Internal helpers


/*
-(void) revertRunningTaskToNormalTime {
    self.runningTaskSequence.speed = 1.0;
    [[KTSoundPlayer sharedInstance] unmute];
    [self.villain show];
}
*/

/*
-(void) resetCurentTaskToTime:(NSTimeInterval) newTimeInSeconds
             timeInBackground:(NSTimeInterval) durationInBg {
    
    // We're going to fast forward to make up for time lost
    // while in the background.
    
    // Hide the villain during fast forwarding avoid confusion, etc.
    //[self.villain hide];
    
    // Fast foward at 100x or whatever
    //float fastForwardFactor = 100.0;
    
    // Avoid balloon popping sounds, etc. while fast forwarding
    //[[KTSoundPlayer sharedInstance] mute];
    
    // Then kick off the actual fast forward
    //self.runningTaskSequence.speed = fastForwardFactor;
    
    // Then set a timer to stop the fast forward
    //NSTimeInterval ffRealTime = durationInBg / fastForwardFactor;
    
    [self performSelector:@selector(revertRunningTaskToNormalTime)
               withObject:nil
               afterDelay:ffRealTime
                  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
    
    // Update the timer separately
    // TODO fast forward this too?
    //    [self.textTimer restartForTime:newTimeInSeconds];
    [self.timer resetToSecondsLeft:newTimeInSeconds];
}
*/

#pragma mark - Routine grading

-(int) routinePerformancePercentage {
    
    // Calculate final percentage score 0-100
    float possiblePoints = (float) [self.routineEntity totalPossiblePoints];
    float earnedPoints = (float) [self.pointCount pointCount];
    float proportionEarned = earnedPoints / possiblePoints;
    int percentageEarned = (int) roundf(proportionEarned * 100);
    
    return percentageEarned;
}

-(NSString*) routinePerformanceRatio {
    return [NSString stringWithFormat:@"%i/%lu", [self.pointCount pointCount], (unsigned long)[self.routineEntity totalPossiblePoints]];
}

-(KTRoutineGrade) routinePerformanceResult {
    
    int percentageEarned = [self routinePerformancePercentage];
    
    if ( percentageEarned > 90 ) {
        return kKTRoutineGradeGood;
    }
    else if ( percentageEarned > 60 ) {
        return kKTRoutineGradeMedium;
    }
    else {
        return kKTRoutineGradeBad;
    }
}

// Calculates proportionally how many poppable balloons out of eleven possible were earned.
// If you got a score of 54% you would get 6 out of 11 possible balloons.
-(int) numBalloonsEarned {
    
    float possiblePoints = (float) [self.routineEntity totalPossiblePoints];
    float earnedPoints = (float) [self.pointCount pointCount];
    
    // Worked this out as a little algebra on paper
    float numEarnedBalloons = earnedPoints * kKTMaxNumRewardBalloons / possiblePoints;
    int retval = (int) roundf(numEarnedBalloons);
    return retval;
}

// Gives the cocos2d coordinates for the poppable reward ballons, in the
// order they should be displayed.
//
// This coordinates will change on the iPad, and could potentially
// even be different for iPhone 4 vs 5, although I used the same set
// for simplicity.
-(NSArray*) rewardBalloonInfo {
    
    CGRect windowBounds = [[RTSAppHelper sharedInstance] windowBoundsForLandscape:YES forCocos2d:YES];
    
    // Nudge up to compensate for the page control on the bottom
    float yAdjust = 36.0;
    
    // These constants map my handwritten paper 12 x 7.5 grid
    // to device coordinates.
    // The "scale" below handles retina, etc.
    float xGridMultiplier = windowBounds.size.width / 12 / [UIScreen mainScreen].scale;
    float yGridMultiplier = (windowBounds.size.height - yAdjust) / 7.5 / [UIScreen mainScreen].scale;
    
    return [NSArray arrayWithObjects:
            
            // 1st column
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(2 * xGridMultiplier,
                                                                      3 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleRed],
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(2 * xGridMultiplier,
                                                                      5 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleRed],
            // 2nd column
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(4 * xGridMultiplier,
                                                                      2 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleBlue],
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(4 * xGridMultiplier,
                                                                      4 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleBlue],
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(4 * xGridMultiplier,
                                                                      6 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleBlue],
            // 3rd column
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(6 * xGridMultiplier,
                                                                      3 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleYellow],
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(6 * xGridMultiplier,
                                                                      5 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleYellow],
            // 4th column
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(8 * xGridMultiplier,
                                                                      2 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleBlue],
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(8 * xGridMultiplier,
                                                                      4 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleBlue],
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(8 * xGridMultiplier,
                                                                      6 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleBlue],
            // 5th column
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(10 * xGridMultiplier,
                                                                      3 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleRed],
            [[KTBalloonCoordAndStyle alloc] initWithCoord:CGPointMake(10 * xGridMultiplier,
                                                                      5 * yGridMultiplier + yAdjust)
                                                    style:kKTBalloonStyleRed],
            nil];
}


#pragma mark - cocos2d plumbing

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	KTRoutineAnimationsLayer *layer = [KTRoutineAnimationsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

#pragma mark - Cocos2d touch event handling

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // First check the close button
    BOOL retval = [self.invisibleCloseButton quitRoutineIfTouched:touch];
    
    if ( ! retval ) {
        // Event not handled yet; check the reward balloons
        if ( self.rewardBalloons ) {
            for (KTUserPoppableBalloon* balloon in self.rewardBalloons) {
                if ( balloon ) {
                    if ( [balloon popIfTouched:touch] ) {
                        retval = YES;
                        break;
                    }
                }
            }
        }
    }
    
    return retval;
}

-(void) pauseAnimations {
    [[CCDirector sharedDirector] pause];
    self.visible = NO;
}

-(void) resumeAnimations {
    [[CCDirector sharedDirector] resume];
    self.visible = YES;
}

// Override this to receive touch events
// http://www.cocos2d-iphone.org/wiki/doku.php/tips:touchdelegates
-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:0
                                                       swallowsTouches:YES];
}

@end
