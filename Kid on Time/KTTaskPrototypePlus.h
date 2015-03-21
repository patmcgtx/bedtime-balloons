//
//  KTTaskPrototypePlus.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/24/14.
//
//

#import "KTTaskPrototype.h"
#import "RTSImageSize.h"

@interface KTTaskPrototype (plusMethods)

+(KTTaskPrototype*) taskPrototype;

-(UIImage*) closeupForTheme:(NSString*) themeName withSize:(RTSImageSize) imageSize;

@end
