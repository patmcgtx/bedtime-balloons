//
//  KTRoutineInfoHeaderView.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 4/6/14.
//
//

#import "KTRoutineInfoHeaderView.h"
#import "KTRoutinePlus.h"
#import "KTDataAccess.h"
#import "KTConstants.h"

@interface KTRoutineInfoHeaderView ()

@property (strong, nonatomic) KTRoutine* routineEntity;

- (IBAction)routineNameChanged:(UITextField *)sender;

@end

@implementation KTRoutineInfoHeaderView

@synthesize isEditing = _isEditing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) attachToRoutine:(KTRoutine*) routine {
    self.routineEntity = routine;
    self.routineNameTextArea.text = routine.name;
    self.routineNameTextArea.delegate = self;
}

/*
-(void) putAwayKeyboard {
    [self.routineNameTextArea resignFirstResponder];
}
*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - KTEditable

-(void) setIsEditing:(BOOL)isEditing {
    
    _isEditing = isEditing;
    
    if ( isEditing ) {
        [UIView animateWithDuration:0.25 animations:^{
            self.routineNameTextArea.enabled = YES;
            self.routineNameTextArea.backgroundColor = [UIColor whiteColor];
            self.routineNameTextArea.clearButtonMode = UITextFieldViewModeAlways;
            self.routineStartButton.enabled = NO;
        } completion:^(BOOL finished) {
            self.routineNameTextArea.borderStyle = UITextBorderStyleRoundedRect;
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            self.routineNameTextArea.enabled = NO;
            self.routineNameTextArea.backgroundColor = [UIColor clearColor];
            self.routineNameTextArea.clearButtonMode = UITextFieldViewModeNever;
            self.routineStartButton.enabled = ([self.routineEntity.tasks count] > 0);
        } completion:^(BOOL finished) {
            self.routineNameTextArea.borderStyle = UITextBorderStyleNone;
        }];
    }
}


#pragma mark - Actions

- (IBAction)routineNameChanged:(UITextField *)sender {
    
    [self.routineEntity updateName:sender.text commit:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationRoutineNameDidChange
                                                        object:self
                                                      userInfo:[NSDictionary
                                                                dictionaryWithObject:self.routineEntity
                                                                forKey:KTKeyRoutineEntity]];
}
@end
