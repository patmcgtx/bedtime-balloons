//
//  KTCocos2dLabel.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface KTCocos2dLabel : NSObject

@property (readonly, nonatomic) CGPoint position;
@property (readonly, strong) CCLabelTTF* label;

- (id)initWithText:(NSString*) labelText
          fontName:(NSString*) fontName
          fontSize:(CGFloat) fontSize
             color:(ccColor3B) color
        hAlignment:(CCTextAlignment) alignment
          forLayer:(CCLayer*) layer
             atPos:(CGPoint) pos
            atZPos:(int) zPos
              hide:(BOOL) hide;

/*
 Targets an action to be always run on myself
 */
- (CCTargetedAction*) actionOnSelf:(CCFiniteTimeAction*) action;

/*
 Builds an action to hide this label
 */
-(CCTargetedAction*) hide;

/*
 Sets a new text value to display
 */
-(void) updateTextImmediately:(NSString*) newText;

/*
 Immediately hides this object from view
 */
-(void) hideImmediately;

@end
