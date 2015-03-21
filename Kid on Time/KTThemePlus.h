//
//  KTTheme+KTThemePlus.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 6/16/13.
//
//

#import "KTTheme.h"

@interface KTTheme (plusMethods)

+(KTTheme*) themeWithName:(NSString*) themeName dislpayOrder:(NSUInteger) displayOrder commit:(BOOL) doCommit;

-(BOOL) isCustomTheme;
-(BOOL) isDefaultTheme;

-(NSString*) localizedName;
-(NSString*) localizedDescription;

-(UIImage*) thumbnail;

@end
