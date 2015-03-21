//
//  KTRoutineInfoHeaderView.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/6/14.
//
//

#import <UIKit/UIKit.h>
#import "KTEditable.h"
#import "KTRoutine.h"

@interface KTRoutineInfoHeaderView : UICollectionReusableView <KTEditable, UITextFieldDelegate>

-(void) attachToRoutine:(KTRoutine*) routine;
//-(void) putAwayKeyboard;

@property (weak, nonatomic) IBOutlet UITextField *routineNameTextArea;
@property (weak, nonatomic) IBOutlet UIButton *routineStartButton;
@property (weak, nonatomic) IBOutlet UIButton *startRoutineButton;

@end
