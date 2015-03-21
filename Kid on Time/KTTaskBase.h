//
//  KTTaskBase.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/9/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KTTaskBase : NSManagedObject

@property (nonatomic, retain) NSNumber * minTimeInSeconds;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * timeInSeconds;
@property (nonatomic, retain) NSString * type;

@end
