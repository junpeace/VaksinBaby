//
//  otherResourcesView.m
//  myVac4Baby
//
//  Created by Jun on 14/10/28.
//  Copyright (c) 2014年 jun. All rights reserved.
//

// http://codehappily.wordpress.com/2013/09/26/ios-how-to-use-uiscrollview-with-auto-layout-pure-auto-layout/

#import "otherResourcesView.h"

@interface otherResourcesView ()

@end

@implementation otherResourcesView

@synthesize revealLeftMenu;
@synthesize lblDescription;

@synthesize btnLikeUsOnFB, btnSignUpENewsLetter, btnVisitOurWebsite;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillDisappear:(BOOL)animated
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) receiveNotification:(NSNotification *) notification
{    
    if ([[notification name] isEqualToString:@"otherResourcesView_receiveNotification_"])
    {
        /* check if user log in */
        
        NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
        
        if (password == nil)
        {
            // loginVC
            
            loginView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            [self.navigationController pushViewController:mmvc animated:YES];
            
            return;
        }
        
        /* redirect user to either read more or update */
        
        if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationType"] intValue] == 1)
        {
            [self performSegueWithIdentifier:@"gotoNotificationSegue" sender:nil];
        }
        else if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationType"] intValue] == 2)
        {
            NSLog(@"update ");
            
            [self performSegueWithIdentifier:@"gotoNotificationSegue" sender:nil];
        }
        else
        { /* invalid condition */ }
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    [self setUpUI];
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"otherResources";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"otherResourcesView_receiveNotification_"
                                               object:nil];
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    // prevent front view from interacting
    if (position == FrontViewPositionRight) { // Menu is shown
        self.navigationController.interactivePopGestureRecognizer.enabled = NO; // Prevents the iOS7’s pan gesture
        self.view.userInteractionEnabled = NO;
    } else if (position == FrontViewPositionLeft) { // Menu is closed
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.view.userInteractionEnabled = YES;
    }
}

-(void) setUpUI
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    self.navigationItem.title = LocalizedString(@"Other Resources");
    
    NSString *str = LocalizedString(@"Immunise4Life (IFL) is an \nexpert-driven community education initiative to promote vaccination for all ages against vaccine-preventable diseases.");
    
    NSRange range = [str rangeOfString:@"("];
    if (range.location == NSNotFound) {
        
        [lblDescription setText:str];
    } else {
        
        NSRange range2 = [str rangeOfString:@")"];
        
        if (range.location == NSNotFound) {
            
        }
        else
        {
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0/255.0f green:172/255.0f blue:244/255.0f alpha:1.0] range:NSMakeRange(range.location, range2.location - range.location + 1)];
            
             [lblDescription setAttributedText: string];
        }
    }
    
    [lblDescription sizeToFit];
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [btnVisitOurWebsite setImage:[UIImage imageNamed:@"bm_btn_visitourwebsite"] forState:UIControlStateNormal];
        [btnLikeUsOnFB setImage:[UIImage imageNamed:@"bm_btn_likeusonfacebook"] forState:UIControlStateNormal];
        [btnSignUpENewsLetter setImage:[UIImage imageNamed:@"bm_btn_signupforenewsletter"] forState:UIControlStateNormal];
    }
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [revealLeftMenu setTarget: self.revealViewController];
        [revealLeftMenu setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0f green:247/255.0f blue:153/255.0f alpha:1.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)visitWebsite:(id)sender
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.ifl.my"]];
}

- (IBAction)visitFacebook:(id)sender
{
    NSURL* facebookURL = [ NSURL URLWithString: @"https://www.facebook.com/Immunise4Life" ];
    NSURL* facebookAppURL = [ NSURL URLWithString: @"fb://profile/1396425660640528" ];
    
    UIApplication* app = [ UIApplication sharedApplication];
    
    if([app canOpenURL: facebookAppURL])
    {
        [app openURL: facebookAppURL];
    }
    else
    {
        [app openURL: facebookURL];
    } 
}

- (IBAction)signUpNewsLetter:(id)sender
{
    [self performSegueWithIdentifier:@"signUpNewsLetterSegue" sender:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"gotoNotificationSegue"])
    {
        bizChild *child = [[bizChild alloc] init];
        [child setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        notificationView *SegueController = (notificationView*)[segue destinationViewController];
        SegueController.child_passBy = child;
    }
}

- (IBAction)home:(id)sender {
    
    mainMenuView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

@end
