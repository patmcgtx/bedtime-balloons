//
//  KTThemeDAO.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTBaseDAO.h"
#import "KTTheme.h"

@interface KTThemeQueries : KTBaseDAO

-(KTTheme*) themeByName:(NSString*) themeName;
-(NSArray*) availableThemes;

@end
