//
//  KTNewRoutineWizardPage1Controller.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 5/18/14.
//
//

#import "KTNewRoutineWizardPage1Controller.h"
#import "ADVTheme.h"
#import "KTConstants.h"
#import "KTNewRoutineTaskPickerController.h"
#import "KTRoutine.h"
#import "KTDataAccess.h"
#import "ELCImagePickerController.h"
#import "KTBlankSlateRoutineCreator.h"
#import "KTCreateRoutineDelegate.h"
#import "KTRoutineNameGenerator.h"
#import "KTPhotoAccessChecker.h"

#define KT_NEW_ROUTINE_SECTION_ROUTINE_NAME 0
#define KT_NEW_ROUTINE_SECTION_ROUTINE_TYPE 1

@interface KTNewRoutineWizardPage1Controller ()

@property (strong, nonatomic) NSIndexPath* lastSelectedTablePath;

@property (weak, nonatomic) IBOutlet UITableViewCell *monkeyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *blankSlateCell;
@property (weak, nonatomic) IBOutlet UITextField *routineNameTextField;

@property (strong, nonatomic) UIBarButtonItem *defaultNextBarButton;
@property (strong, nonatomic) UIBarButtonItem *blankSlateNextBarButton;

@property (strong, nonatomic) KTBlankSlateRoutineCreator* blankSlateCreator;
@property (strong, nonatomic) ELCImagePickerController* multiIimagePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navBarNextButton;
@property (weak, nonatomic) IBOutlet UIButton *bigNextButton;

@property (weak, nonatomic) IBOutlet UILabel *monkeyRoutineTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *monkeyRoutineDescriptionView;
@property (weak, nonatomic) IBOutlet UILabel *blankSlateRoutineTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *blankSlateRoutineDescriptionView;

- (IBAction)cancel:(id)sender;
- (IBAction)next:(id)sender;

@end

@implementation KTNewRoutineWizardPage1Controller

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [ADVTheme viewBackgroundColor];
    
    self.navBarNextButton.title = NSLocalizedString(@"action.next", nil);
    [self.bigNextButton setTitle:[NSLocalizedString(@"action.next", nil) uppercaseString] forState:UIControlStateNormal];
    self.title = NSLocalizedString(@"title.routine.create", nil);
    
    self.monkeyRoutineTitleLabel.text = NSLocalizedString(@"theme.default.name", nil);
    self.monkeyRoutineDescriptionView.text = NSLocalizedString(@"theme.default.description", nil);
    
    self.blankSlateRoutineTitleLabel.text = NSLocalizedString(@"theme.custom.name", nil);
    self.blankSlateRoutineDescriptionView.text = NSLocalizedString(@"theme.custom.description", nil);
    
    // This object will get notified when all the images are selected for blank slate routines.
    self.blankSlateCreator = [[KTBlankSlateRoutineCreator alloc] init];
    self.blankSlateCreator.delegate = self;

    self.multiIimagePicker = [[ELCImagePickerController alloc] initImagePicker];
    self.multiIimagePicker.maximumImagesCount = KTImagePickerMaxImages; 
    self.multiIimagePicker.returnsOriginalImage = KTImagePickerReturnsOriginal;
    self.multiIimagePicker.imagePickerDelegate = self.blankSlateCreator;
    
    self.routineNameTextField.text = [KTRoutineNameGenerator generateLocalizedRoutineName];
    
    self.routineNameTextField.delegate = self;
    
    // Keyboard stuff
    UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    // Start editing the routine name
    //[self.routineNameTextField becomeFirstResponder];
    
    // Pre-select the monkey theme as default
    self.monkeyCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.lastSelectedTablePath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView selectRowAtIndexPath:self.lastSelectedTablePath animated:NO scrollPosition:0];
    
    // De-select the other themes
    self.blankSlateCell.accessoryType = UITableViewCellAccessoryNone;
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Prepare bar button items
    self.defaultNextBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"action.next", nil)
                                                          style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(finishDefaultRoutine)];
    
    self.blankSlateNextBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"action.next", nil)
                                                                    style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(finishBlankSlateRoutine)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If the selection changed...
    if ( indexPath.section == 1 ) {
        if ( ! [indexPath isEqual:self.lastSelectedTablePath] ) {
            
            // Uncheck the previous selection
            UITableViewCell* previousSelection = [self.tableView cellForRowAtIndexPath:self.lastSelectedTablePath];
            previousSelection.accessoryType = UITableViewCellAccessoryNone;
            [previousSelection setSelected:NO animated:YES];
            
            // Check the new selection
            UITableViewCell* newSelection = [self.tableView cellForRowAtIndexPath:indexPath];
            newSelection.accessoryType = UITableViewCellAccessoryCheckmark;
            [newSelection setSelected:YES animated:YES];
            
            self.lastSelectedTablePath = indexPath;
            
            // Update controls
            if ( [self.selectedThemeName isEqualToString:kKTThemeNameDefault] ) {
                self.navigationItem.rightBarButtonItem = self.defaultNextBarButton;
            }
            else if ( [self.selectedThemeName isEqualToString:kKTThemeNameCustom] ) {
                self.navigationItem.rightBarButtonItem = self.blankSlateNextBarButton;
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSIndexPath* retval = indexPath;
    UITableViewCell* cellToBeSelected = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Prevent selecting the "Next" cell
    if (cellToBeSelected.tag == 99) {
        retval = nil;
    }
    
    return retval;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* stringKey = nil;
    
    switch (section) {

        case KT_NEW_ROUTINE_SECTION_ROUTINE_NAME:
            stringKey = @"newroutine.name.title";
            break;
            
        case KT_NEW_ROUTINE_SECTION_ROUTINE_TYPE:
            stringKey = @"newroutine.type.title";
            break;
            
        default:
            break;
    }
    
    return NSLocalizedString(stringKey, nil);
}
*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.routineNameTextField resignFirstResponder];
    return YES;
}

#pragma mark - Segues

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue.identifier isEqualToString:@"newRoutineToTaskList"]
        || [segue.identifier isEqualToString:@"newRoutineToTaskList2"]) {
        KTNewRoutineTaskPickerController* destController = (KTNewRoutineTaskPickerController*) segue.destinationViewController;
        destController.createRoutineName = self.routineNameTextField.text;
        destController.createRoutineThemeName = [self selectedThemeName];
    }
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)next:(id)sender {
    if ( [self.selectedThemeName isEqualToString:kKTThemeNameDefault] ) {
        [self finishDefaultRoutine];
    }
    else {
        [self finishBlankSlateRoutine];
    }
}

-(void) finishDefaultRoutine {
    [self performSegueWithIdentifier:@"newRoutineToTaskList" sender:self];
}

-(void) finishBlankSlateRoutine {
    
    if ( self.multiIimagePicker ) {
        if ( [KTPhotoAccessChecker vetPhotoAccess] ) {
            self.blankSlateCreator.routineName = self.routineNameTextField.text;
            [self presentViewController:self.multiIimagePicker animated:YES completion:nil];
        }
    }
}

#pragma mark - KTCreateRoutineDelegate

-(void) didFinishRoutineCreation:(KTRoutine*) addedRoutine {
    // Dismiss the image picker...
    [self.multiIimagePicker dismissViewControllerAnimated:NO completion:^{
        // Then dismiss myself...
        [self dismissViewControllerAnimated:YES completion:^{
            // Then animate the addition of the new routine.
            [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationDidAddRoutine
                                                                object:self
                                                              userInfo:[NSDictionary
                                                                        dictionaryWithObject:addedRoutine
                                                                        forKey:KTKeyRoutineEntity]];
        }];
    }];
}

-(void) didCancelRoutineCreation {
    // Just dismiss the image picker
    [self.multiIimagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Internal

-(NSString*) selectedThemeName {
    
    NSString* retval = nil;
    
    if ( [self.lastSelectedTablePath isEqual:[self.tableView indexPathForCell:self.monkeyCell]] ) {
        retval = kKTThemeNameDefault;
    }
    else if ( [self.lastSelectedTablePath isEqual:[self.tableView indexPathForCell:self.blankSlateCell]] ) {
        retval = kKTThemeNameCustom;
    }
    
    return retval;
}

-(void) dismissKeyboard {
    [self.routineNameTextField resignFirstResponder];
}

@end
