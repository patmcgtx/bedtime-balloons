//
//  KTRoutineRunContentViewController.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTRoutineRunTaskPageController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *taskImageView;

/* 
 Each time the user turns a page in the application, the data source methods for a 
 UIPageViewController object are going to create a new instance of our 
 contentViewController class and set the dataObject property of that instance to the HTML 
 that is to be displayed on the web view object
*/
@property (strong, nonatomic) id dataObject;

@end
