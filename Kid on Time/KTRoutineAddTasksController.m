//
//  KTRoutineAddTasksController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/26/14.
//
//

#import "KTRoutineAddTasksController.h"
#import "KTDataAccess.h"
#import "KTConstants.h"
#import "KTTaskPlus.h"
#import "KTRoutinePlus.h"

@interface KTRoutineAddTasksController ()

- (IBAction)done:(id)sender;

@end

@implementation KTRoutineAddTasksController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    
    NSMutableOrderedSet* tasksToAdd = [NSMutableOrderedSet orderedSetWithCapacity:[self.selectedTaskPrototypes count]];
    
    for ( KTTaskPrototype* proto in self.selectedTaskPrototypes ) {
        KTTask* taskToAdd = [KTTask taskFromPrototype:proto commit:NO];
        [tasksToAdd addObject:taskToAdd];
    }
    
    [self.routineEntity insertTasksAtBeginning:tasksToAdd commit:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationRoutineTasksDidChange
                                                        object:self
                                                      userInfo:[NSDictionary
                                                                dictionaryWithObject:self.routineEntity
                                                                forKey:KTKeyRoutineEntity]];

    NSNumber* numberOfTasksAdded = [NSNumber numberWithUnsignedInteger:[tasksToAdd count]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Animate the task additions after returning to the parent view
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationDidAddTasksToRoutine
                                                            object:self
                                                          userInfo:@{ KTKeyRoutineEntity : self.routineEntity,
                                                                      KTKeyNumberOfItems : numberOfTasksAdded }];
    }];
}

@end
