//
//  KTRoutineAddTasksBaseController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/26/14.
//
//

#import "KTRoutineAddTasksBaseController.h"
#import "KTTaskPrototypePlus.h"
#import "KTDataAccess.h"
#import "ADVTheme.h"
#import "KTConstants.h"
#import "RTSImageSize.h"
#import "KTTaskTypes.h"

@interface KTRoutineAddTasksBaseController ()

@end

@implementation KTRoutineAddTasksBaseController

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
    
    // Query the routines from the databaase
    KTTaskQueries* taskDAO = [[KTDataAccess sharedInstance] taskQueries];
    self.taskPrototypeEntities = [[taskDAO getTaskPrototypes] mutableCopy];
    
    // We don't want to include custom tasks here
    KTTaskPrototype* customTaskProto = [taskDAO getTaskPrototypeByType:kKTTaskTypeCustom];
    [self.taskPrototypeEntities removeObject:customTaskProto];
    
    self.selectedTaskPrototypes = [NSMutableArray array];
    
    self.tableView.backgroundColor = [ADVTheme viewBackgroundColor];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    self.editing = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.taskPrototypeEntities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* reuseId = @"taskTypeCell";
    UITableViewCell* taskTypeCell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (taskTypeCell == nil) {
        taskTypeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    taskTypeCell.selected = NO;
    taskTypeCell.accessoryType = UITableViewCellAccessoryNone;
    
	KTTaskPrototype* taskProto = [self taskPrototypeForIndexPath:indexPath];
    taskTypeCell.textLabel.text = taskProto.name;
    
    // Assume only default theme for now...
    taskTypeCell.imageView.image = [taskProto closeupForTheme:kKTThemeNameDefault withSize:RTSImageSizeSmall];
    
    return taskTypeCell;
}

/*
 - (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return @"Tasks for the routine";
 }
 */
/*
 - (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
 return @"Tasks can be changed later.";
 }
 */

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:NO];
    
    UITableViewCell* cell = [theTableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.selectedTaskPrototypes addObject:[self taskPrototypeForIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)theTableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [theTableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [self.selectedTaskPrototypes removeObject:[self taskPrototypeForIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // First just update the overall task list, selected or not
    id objToMove = [self.taskPrototypeEntities objectAtIndex:sourceIndexPath.row];
    [self.taskPrototypeEntities removeObject:objToMove];
    [self.taskPrototypeEntities insertObject:objToMove atIndex:destinationIndexPath.row];
    
    // Then update the order of any selected tasks
    NSArray* oldSelectedTaskPrototypes = [NSArray arrayWithArray:self.selectedTaskPrototypes];
    self.selectedTaskPrototypes = [NSMutableArray array];
    
    for (id aTaskPrototype in self.taskPrototypeEntities) {
        if ([oldSelectedTaskPrototypes containsObject:aTaskPrototype]) {
            [self.selectedTaskPrototypes addObject:aTaskPrototype];
        }
    }
}

#pragma mark - Internal

- (KTTaskPrototype*) taskPrototypeForIndexPath:(NSIndexPath *)indexPath {
	return [self.taskPrototypeEntities objectAtIndex:indexPath.row];
}

@end
