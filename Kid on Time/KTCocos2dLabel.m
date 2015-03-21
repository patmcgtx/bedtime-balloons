//
//  KTCocos2dLabel.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KTCocos2dLabel.h"

@interface KTCocos2dLabel ()

@property (readonly, nonatomic) CCLayer* layer;
@property (readonly, nonatomic) CGPoint startingPosition;
@property (readonly, nonatomic) int startingZPosition;
@property (readonly, nonatomic) BOOL startHidden;

@end

@implementation KTCocos2dLabel

@synthesize label = _label;
@synthesize layer = _layer;
@synthesize startingPosition = _startingPosition;
@synthesize startingZPosition = _startingZPosition;
@synthesize startHidden = _startHidden;

- (id)initWithText:(NSString*) labelText
          fontName:(NSString*) fontName
          fontSize:(CGFloat) fontSize
             color:(ccColor3B) color
        hAlignment:(CCTextAlignment) alignment
          forLayer:(CCLayer*) layer
             atPos:(CGPoint) pos
            atZPos:(int) zPos
              hide:(BOOL) hide {

    self = [super init];
    
    if (self) {        
        // Save these for later
        _layer = layer;
        _startingPosition = pos;
        _startingZPosition = zPos;
        _startHidden = hide;
        
        
        // Set up the cocos2d label
        // (I would call [self reset], but I don't think you can do from insidee init.)
        _label = [CCLabelTTF labelWithString:labelText fontName:fontName fontSize:fontSize];
        
        _label.horizontalAlignment = alignment;
        _label.position = pos;
        _label.visible = ! hide;
        _label.color = color;
        
        // Add to the cocos2d layer
        [layer addChild:_label z:zPos];
    }
    
    return self;
    
}

#pragma mark - Properties
-(CGPoint) position {
    return self.label.position;
}

#pragma mark - Action builders

- (CCTargetedAction*) actionOnSelf:(CCFiniteTimeAction*) action {
    return [CCTargetedAction actionWithTarget:self.label 
                                       action:action];    
}

-(CCTargetedAction*) hide {
    CCHide* hide = [CCHide action];    
    return [self actionOnSelf:hide];
}

#pragma mark - Immediate state changers

-(void) updateTextImmediately:(NSString*) newText {
    self.label.string = newText;
}

-(void) hideImmediately {
    self.label.visible = NO;
}


@end
