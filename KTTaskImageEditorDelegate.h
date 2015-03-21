//
//  KTTaskImageEditorDelegate.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 8/5/14.
//
//

#import <Foundation/Foundation.h>

@protocol KTImageEditorDelegate <NSObject>

// The delegate provides the image to edit
-(UIImage*) imageForImageEditor;

-(void) imageEditorDidFinishWithImage:(UIImage*) editedImage;

-(BOOL) imageEditorIsForBlankSlateRoutine;

@end
