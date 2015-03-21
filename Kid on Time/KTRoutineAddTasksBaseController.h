//
//  KTRoutineAddTasksBaseController.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/26/14.
//
//

#import <UIKit/UIKit.h>
#import "KTTaskPrototype.h"

@interface KTRoutineAddTasksBaseController : UITableViewController

@property (nonatomic, strong) NSMutableArray* taskPrototypeEntities;
@property (nonatomic, strong) NSMutableArray* selectedTaskPrototypes;

- (KTTaskPrototype*) taskPrototypeForIndexPath:(NSIndexPath *)indexPath;

@end
