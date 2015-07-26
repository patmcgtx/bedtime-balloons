//
//  KTTaskPlus.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTTask.h"
#import "RTSImageSize.h"
#import "KTTaskPrototype.h"
#import "KTTaskImageState.h"

/*
 * Add methods to the CoreData-generated task entity class.
 * This class adds custom logic to do calculations, manipluations, etc.
 * on the core data.
 */
@interface KTTask (plusMethods)

@property KTTaskImageState imageState;

// Creates empty and and does not commit
+(KTTask*) task;

+(KTTask*) taskFromPrototype:(KTTaskPrototype*) prototype commit:(BOOL) doCommit;
+(KTTask*) taskFromPrototype:(KTTaskPrototype*) prototype name:(NSString*) taskName commit:(BOOL) doCommit;

// Returns true if an update is necessary, false otherwise
-(BOOL) mayebUpdateName:(NSString*) taskName minTimeInSecs:(NSUInteger) minSecs maxTimeInSecs:(NSUInteger) maxSecs commit:(BOOL) doCommit;

/*
 Gets an image to visually represent the task.  May either be a standard
 task image from a theme, or a custom image;
 */
-(UIImage*) imageWithSize:(RTSImageSize) imageSize;

/*!
 Gets a low-resolution iCloud image preview, accesible before the full iCloud image is downloaded.
 @return The low-rez image, or nil if there is no preview image, such as with built-in tasks.
 */
//-(UIImage*) placeholderImage;

/*!
 Saves a low-resolution iCloud image preview, accesible before the full iCloud image is downloaded
 */
//-(void) savePlaceholderImage:(UIImage*) placeholderImage;

-(void) saveCustomImage:(UIImage*) customImage incudingOriginal:(BOOL) saveOriginal;

-(void) deleteCustomImages;

-(NSUInteger) minTimeInMinutes;
-(NSUInteger) maxTimeInMinutes;

// These return nil if N/A
-(KTTask*) nextTask;
-(KTTask*) previousTask;

// Where is this task located within its routine? (zero-indexed)
-(NSUInteger) indexWithinRoutine;

@end
