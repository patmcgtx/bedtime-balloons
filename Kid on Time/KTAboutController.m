//
//  KTAboutController.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 7/5/14.
//
//

#import "KTAboutController.h"

#define KT_ABOUT_CONTROLLER_SECTION_CONTACT 0
#define KT_ABOUT_CONTROLLER_SECTION_LINKS 1
#define KT_ABOUT_CONTROLLER_SECTION_ART 2
#define KT_ABOUT_CONTROLLER_SECTION_RTSAPPS 3
#define KT_ABOUT_CONTROLLER_SECTION_CREDITS 4
#define KT_ABOUT_CONTROLLER_SECTION_VERSION 5

@interface KTAboutController ()

@property (weak, nonatomic) UITableViewCell* lastSelectedCell;
@property (strong, nonatomic) NSDictionary* cellTagsToCopyText;
@property (strong, nonatomic) NSString* appVersion;

@property (weak, nonatomic) IBOutlet UILabel *privacyPolicyLabel;
@property (weak, nonatomic) IBOutlet UILabel *illustrationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *appStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *appStoreSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *mathCardsTitle;
@property (weak, nonatomic) IBOutlet UILabel *mathCardsSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *santaTitle;
@property (weak, nonatomic) IBOutlet UILabel *santaSubtitle;

@end

@implementation KTAboutController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"tab.about.title", nil);
    
    self.appVersion = [NSString stringWithFormat:@"%@ (%@)",
                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    self.versionLabel.text = self.appVersion;
    
    self.illustrationsLabel.text = NSLocalizedString(@"about.art.illustrations.description", nil);
    self.privacyPolicyLabel.text = NSLocalizedString(@"privacy.policy", nil);
    self.onlineHelpLabel.text = NSLocalizedString(@"about.help.title", nil);
    self.appStoreLabel.text = NSLocalizedString(@"about.appstore.title", nil);
    self.appStoreSubtitle.text = NSLocalizedString(@"about.appstore.subtitle", nil);
    self.mathCardsTitle.text = NSLocalizedString(@"about.rtsapps.mathcards.title", nil);
    self.mathCardsSubtitle.text = NSLocalizedString(@"about.rtsapps.mathcards.subtitle", nil);
    self.santaTitle.text = NSLocalizedString(@"about.rtsapps.santa.title", nil);
    self.santaSubtitle.text = NSLocalizedString(@"about.rtsapps.santa.subtitle", nil);
    
    // This is where we provide URLs to copy if you tap on the cell with the associated tag
    self.cellTagsToCopyText = @{@"10" : NSLocalizedString(@"app.help.url", nil),
                            @"11" : NSLocalizedString(@"rts.email.url", nil),
                            @"12" : NSLocalizedString(@"twitter.web.url", nil),
                            @"13" : NSLocalizedString(@"facebook.web.url", nil),
                            @"30" : @"Francesca Da Sacco",
                            @"71" : NSLocalizedString(@"app.mathcards.itunes.url", nil),
                            @"72" : NSLocalizedString(@"app.santa.itunes.url", nil),
                            @"40" : @"http://www.cocos2d-iphone.org",
                            @"41" : @"https://github.com/lukescott/DraggableCollectionView",
                            @"42" : @"https://github.com/B-Sides/ELCImagePickerController",
                            @"44" : @"https://github.com/buildmobile/iosrangeslider",
                            @"45" : @"https://www.plcrashreporter.org",
                            @"46" : @"http://www.flaticon.com/free-icon/plus-sign-ios-7-interface-symbol_22245",
                            @"47" : @"https://github.com/mustangostang/UIImage-ResizeMagick",
                            @"50" : NSLocalizedString(@"app.help.url", nil),
                            @"51" : NSLocalizedString(@"app.itunes.url", nil),
                            @"60" : self.appVersion
                            };
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.lastSelectedCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ( [self tableView:tableView canPerformAction:@selector(copy:) forRowAtIndexPath:indexPath withSender:self]) {
        [self becomeFirstResponder];
        UIMenuController* theMenu = [UIMenuController sharedMenuController];
        [theMenu setTargetRect:self.lastSelectedCell.frame inView:self.view];
        [theMenu setMenuVisible:YES animated:YES];
    }
}

-(BOOL) canBecomeFirstResponder {
    return YES;
}

-(BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    return ( action == @selector(copy:) && [self urlForLastSelectedCell] != nil);
}

-(NSString*) urlForLastSelectedCell {
    NSString* cellTagAsString = [[NSNumber numberWithLong:self.lastSelectedCell.tag] stringValue];
    return [self.cellTagsToCopyText valueForKey:cellTagAsString];
}

- (void)copy:(id)sender {
    
    NSString* urlToCopyToClipboard = [self urlForLastSelectedCell];
    
    if ( urlToCopyToClipboard ) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setString:urlToCopyToClipboard];
    }
}

-(BOOL)tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath {
    return (indexPath.section == KT_ABOUT_CONTROLLER_SECTION_CREDITS
            || (indexPath.section == KT_ABOUT_CONTROLLER_SECTION_CONTACT));
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* stringKey = nil;
    
    switch (section) {
            
        case KT_ABOUT_CONTROLLER_SECTION_CONTACT:
            stringKey = @"about.contact.title";
            break;

        case KT_ABOUT_CONTROLLER_SECTION_RTSAPPS:
            stringKey = @"about.rtsapps.title";
            break;

        case KT_ABOUT_CONTROLLER_SECTION_ART:
            stringKey = @"about.art.title";
            break;
            
        case KT_ABOUT_CONTROLLER_SECTION_CREDITS:
            stringKey = @"about.credits.title";
            break;
            
        case KT_ABOUT_CONTROLLER_SECTION_VERSION:
            stringKey = @"label.app.version";
            break;
            
        default:
            break;
    }

    return NSLocalizedString(stringKey, nil);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NSString* stringKey = nil;
    
    switch (section) {
            
        case KT_ABOUT_CONTROLLER_SECTION_CONTACT:
            stringKey = @"about.contact.footer";
            break;
            
        default:
            break;
    }
    
    return NSLocalizedString(stringKey, nil);    
}

@end
