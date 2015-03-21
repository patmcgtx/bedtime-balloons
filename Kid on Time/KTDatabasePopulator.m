//
//  KTDataPopulator.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTDatabasePopulator.h"
#import "RTSLog.h"
#import "KTTask.h"
#import "KTTaskBasePlus.h"
#import "KTDataAccess.h"
#import "KTTaskQueries.h"
#import "KTThemeQueries.h"
#import "KTTaskTypes.h"
#import "KTConstants.h"
#import "KTRoutinePlus.h"
#import "KTTaskPlus.h"
#import "KTTaskPrototypePlus.h"
#import "KTThemePlus.h"
#import <CoreData/CoreData.h>

#define kKTDatabasePopulatorTaskKeyName @"name"
#define kKTDatabasePopulatorTaskKeyMinTime @"mintime"
#define kKTDatabasePopulatorTaskKeyMaxTime @"maxtime"
#define kKTDatabasePopulatorTaskKeyType @"type"

@implementation KTDatabasePopulator

- (KTTheme*) addThemeWithNameKey:(NSString*) nameKey
                    displayOrder:(int) displayOrder
{
    KTTheme* themeRecord = [KTTheme themeWithName:nameKey dislpayOrder:displayOrder commit:YES];    
    return themeRecord;
}


- (KTTaskPrototype*) addTaskPrototypeWithNameKey:(NSString*) name
                                         type:(NSString*) type
                                 displayOrder:(int) displayOrder
                                maxTimeInSecs:(int) maxTime
                                 minTmeInSecs:(int) minTime
{
    KTTaskPrototype* protoRecord = [KTTaskPrototype taskPrototype];
    
    protoRecord.name = NSLocalizedString(name, nil);
    protoRecord.type = type;
    protoRecord.displayOrder = [NSNumber numberWithInt:displayOrder];
    protoRecord.timeInSeconds = [NSNumber numberWithInt:maxTime];
    protoRecord.minTimeInSeconds = [NSNumber numberWithInt:minTime];
        
    return protoRecord;
}

- (void) populateDbIfEmpty {
            
    if ( [self isDbEmpty] ) {
        
        [self addTaskPrototypeWithNameKey:@"task.prototype.custom.label"
                                  type:kKTTaskTypeCustom
                          displayOrder:0
                         maxTimeInSecs:300
                          minTmeInSecs:0];
        
        KTTaskPrototype* protoBath = [self addTaskPrototypeWithNameKey:@"task.prototype.bath.label"
                                  type:kKTTaskTypeBath
                          displayOrder:5
                         maxTimeInSecs:1200
                          minTmeInSecs:0];
        
        [self addTaskPrototypeWithNameKey:@"task.prototype.shower.label"
                                     type:kKTTaskTypeShower
                             displayOrder:10
                            maxTimeInSecs:600
                             minTmeInSecs:0];
        
        KTTaskPrototype* protoPajamas = [self addTaskPrototypeWithNameKey:@"task.prototype.pajamas.label"
                                  type:kKTTaskTypePajamas
                          displayOrder:15
                         maxTimeInSecs:180
                          minTmeInSecs:0];
        
        KTTaskPrototype* protoTeeth = [self addTaskPrototypeWithNameKey:@"task.prototype.teeth.label"
                                  type:kKTTaskTypeTeeth
                          displayOrder:20
                         maxTimeInSecs:240
                          minTmeInSecs:60];
        
        KTTaskPrototype* protoHair = [self addTaskPrototypeWithNameKey:@"task.prototype.hair.label"
                                  type:kKTTaskTypeHair
                          displayOrder:25
                         maxTimeInSecs:120
                          minTmeInSecs:0];
        
        KTTaskPrototype* protoBathroom = [self addTaskPrototypeWithNameKey:@"task.prototype.bathroom.label"
                                  type:kKTTaskTypeBathroom
                          displayOrder:30
                         maxTimeInSecs:180
                          minTmeInSecs:0];

        KTTaskPrototype* protoHands = [self addTaskPrototypeWithNameKey:@"task.prototype.hands.label"
                                  type:kKTTaskTypeHands
                          displayOrder:35
                         maxTimeInSecs:120
                          minTmeInSecs:0];
        
        KTTaskPrototype* protoStory = [self addTaskPrototypeWithNameKey:@"task.prototype.story.label"
                                  type:kKTTaskTypeStory
                          displayOrder:40
                         maxTimeInSecs:900
                          minTmeInSecs:0];
        
        [self addThemeWithNameKey:kKTThemeNameDefault displayOrder:1];
        [self addThemeWithNameKey:kKTThemeNameCustom displayOrder:2];

        NSMutableOrderedSet* routineTasks = [NSMutableOrderedSet orderedSet];
        
        [routineTasks addObject:[KTTask taskFromPrototype:protoBath commit:NO]];
        [routineTasks addObject:[KTTask taskFromPrototype:protoPajamas commit:NO]];
        [routineTasks addObject:[KTTask taskFromPrototype:protoHair commit:NO]];
        [routineTasks addObject:[KTTask taskFromPrototype:protoTeeth commit:NO]];
        [routineTasks addObject:[KTTask taskFromPrototype:protoBathroom commit:NO]];
        [routineTasks addObject:[KTTask taskFromPrototype:protoHands commit:NO]];
        [routineTasks addObject:[KTTask taskFromPrototype:protoStory commit:NO]];
        
        [KTRoutine routineWithName:NSLocalizedString(@"routine.name.sample", nil)
                         themeName:kKTThemeNameDefault
                             tasks:routineTasks commit:YES];
    }
    else {
        LOG_INFO(@"The database is NOT empty; leaving alone");
    }
    
}

- (BOOL) isDbEmpty {
    NSArray* taskPrototypes = [[[KTDataAccess sharedInstance] taskQueries] getTaskPrototypes];
    return ([taskPrototypes count] < 1);
}

@end
