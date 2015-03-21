//
//  KTRoutineTaskPIckerController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/18/14.
//
//

#import "KTNewRoutineTaskPickerController.h"
#import "KTTaskPrototype.h"
#import "KTDataAccess.h"
#import "ADVTheme.h"
#import "KTConstants.h"
#import "KTTaskPrototypePlus.h"
#import "KTRoutinePlus.h"
#import "KTTaskPlus.h"

@interface KTNewRoutineTaskPickerController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

- (IBAction)done:(id)sender;

//- (KTTaskPrototype*) taskPrototypeForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation KTNewRoutineTaskPickerController

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
    
    self.title = NSLocalizedString(@"title.tasks.pick", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBar.title = self.createRoutineName;
}

#pragma mark - UITableViewDataSource

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return NSLocalizedString(@"add.photos.later", nil);
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    
    NSMutableOrderedSet* tasksToAdd = [NSMutableOrderedSet orderedSetWithCapacity:[self.selectedTaskPrototypes count]];
    
    for ( KTTaskPrototype* proto in self.selectedTaskPrototypes ) {
        KTTask* taskToAdd = [KTTask taskFromPrototype:proto commit:NO];
        [tasksToAdd addObject:taskToAdd];
    }
    
    KTRoutine* addedRoutine = [KTRoutine routineWithName:self.createRoutineName
                                               themeName:self.createRoutineThemeName
                                                   tasks:tasksToAdd
                                                  commit:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Animate the addition after returning to the parent view
        [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationDidAddRoutine
                                                            object:self
                                                          userInfo:[NSDictionary
                                                                    dictionaryWithObject:addedRoutine
                                                                    forKey:KTKeyRoutineEntity]];
    }];
}

@end
