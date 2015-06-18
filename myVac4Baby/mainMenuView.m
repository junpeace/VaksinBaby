//
//  mainMenuView.m
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "mainMenuView.h"

@interface mainMenuView ()

@end

@implementation mainMenuView

@synthesize revealLeftMenu;
@synthesize imgOtherResources, imgReminder, imgReportAdverseEffect, imgVaccinationTracker, imgVaccinePreventableDiseases, imgVideo;
@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // [self testCode];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"mainMenu_receivseNotification"])
    {
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

-(void) testCode
{
    // create 2nd notification to compare with 1st notification layout
    
    // date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    // child's birthday
    NSString *currentDate = [NSString stringWithFormat:@"2015-02-15 23:23:00"];
    NSDate *dt = [dateFormatter dateFromString:currentDate];
    
    NSLog(@"baby bday : %@", dt);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 184 1 2
    
    [dict setValue:@"184" forKey:@"childId"];
    [dict setValue:@"8" forKey:@"pushNotificationId"];
    [dict setValue:@"https://myvac4baby.s3.amazonaws.com/child/babyImg131416327587.png" forKey:@"childImgUrl"];
    [dict setValue:@"1" forKey:@"pushNotificationType"];
    
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = dt;
    
    localNotification.alertBody = @"Vaccination Tracker Update - Mummy, please remember to update my Vaccination Tracker";
    
    localNotification.alertAction = @"MyVac 4 Baby";
    
    localNotification.userInfo = dict;
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // child's birthday
    /*NSString *currentDate2 = [NSString stringWithFormat:@"2015-01-29 13:11:28"];
     NSDate *dt2 = [dateFormatter dateFromString:currentDate2];
     
     NSLog(@"baby bday : %@", dt2);
     
     NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
     
     [dict2 setValue:@"32" forKey:@"childId"];
     [dict2 setValue:@"8" forKey:@"pushNotificationId"];
     [dict2 setValue:@"https://myvac4baby.s3.amazonaws.com/child/babyImg131416327587.png" forKey:@"childImgUrl"];
     [dict2 setValue:@"2" forKey:@"pushNotificationType"];
     
     // Schedule the notification
     UILocalNotification* localNotification2 = [[UILocalNotification alloc] init];
     
     localNotification2.fireDate = dt2;
     
     localNotification2.alertBody = @"Vaccination Tracker Update - Mummy, please remember to update my Vaccination Tracker";
     
     localNotification2.alertAction = @"MyVac 4 Baby";
     
     localNotification2.userInfo = dict2;
     
     localNotification2.timeZone = [NSTimeZone defaultTimeZone];
     
     localNotification2.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
     
     localNotification2.soundName = UILocalNotificationDefaultSoundName;
     
     [[UIApplication sharedApplication] scheduleLocalNotification:localNotification2];*/
    
    NSLog(@"done");
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    [self setUpView];
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"mainMenu";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"mainMenu_receivseNotification"
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

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    revealViewController.navigationController.navigationBar.hidden = YES;
    
    if ( revealViewController )
    {
        [revealLeftMenu setTarget: self.revealViewController];
        [revealLeftMenu setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0f green:247/255.0f blue:153/255.0f alpha:1.0];
    }
}

-(void) setUpView
{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [imgReminder setImage:[UIImage imageNamed:@"bm_btn_reminders"]];
        [imgVaccinationTracker setImage:[UIImage imageNamed:@"bm_btn_vaccinationtracker"]];
        [imgVaccinePreventableDiseases setImage:[UIImage imageNamed:@"bm_btn_vaccinepreventablediseases"]];
        [imgOtherResources setImage:[UIImage imageNamed:@"bm_btn_otherresources"]];
        [imgReportAdverseEffect setImage:[UIImage imageNamed:@"bm_btn_reportadverseeffect"]];
        [imgVideo setImage:[UIImage imageNamed:@"bm_btn_videos"]];
    }
    
    imgReminder.userInteractionEnabled = YES;
    imgVideo.userInteractionEnabled = YES;
    imgOtherResources.userInteractionEnabled = YES;
    imgVaccinationTracker.userInteractionEnabled = YES;
    imgVaccinePreventableDiseases.userInteractionEnabled = YES;
    imgReportAdverseEffect.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert1:)];
    tap.numberOfTapsRequired = 1;
    [imgReminder addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert2:)];
    tap.numberOfTapsRequired = 1;
    [imgVideo addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert3:)];
    tap.numberOfTapsRequired = 1;
    [imgOtherResources addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert4:)];
    tap.numberOfTapsRequired = 1;
    [imgVaccinationTracker addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert5:)];
    tap.numberOfTapsRequired = 1;
    [imgVaccinePreventableDiseases addGestureRecognizer:tap5];
    
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert6:)];
    tap.numberOfTapsRequired = 1;
    [imgReportAdverseEffect addGestureRecognizer:tap6];
    
    // set different image in case of user did not login
    [self displayDifferentImage];
    
    // determine the status of right navigation item
    [self changeLockIconStatus];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.viewWidthConstraint.constant = screenWidth;
    // self.viewHeightConstraint.constant = screenHeight;
    

    // remove the scroll behavior
    if(screenHeight == 568)
    {
        /* 4 inch - tested on ipod */
        
        self.viewHeightConstraint.constant = 500;
    }
    else if(screenHeight == 667)
    {
        /* iphone 6 */
        
        self.viewHeightConstraint.constant = 600;
    }
    else
    {
        /* iphone 6 plus (736) */
        self.viewHeightConstraint.constant = screenHeight;
    }
    
    
    // adjust the position of menu button for different screen size
    if(screenWidth > 320)
    {
        int toBeMoved = (screenWidth - 320) / 4;
        
        self.btnReminderPositionX_Constraint.constant = toBeMoved;
        self.btnVaccinationPositionX_Constraint.constant = toBeMoved;
        self.btnVideoPositionX_Constraint.constant = toBeMoved;
        self.btnVaccinePreventableDiseasePositionX_Constraint.constant = toBeMoved;
        self.btnOtherResourcesPositionX_Constraint.constant = toBeMoved;
        self.btnReportAdverseEffectPositionX_Constraint.constant = toBeMoved;
    }
    
    NSLog(@"screen height : %f", screenHeight);
    
    if(screenHeight > 568)
    {
        int toBeMoved = (screenHeight - 568) / 4;
        
        self.btnReminderPositionY_Constraint.constant += toBeMoved;
        self.btnVaccinationTrackerPositionY_Constraint.constant += toBeMoved;
        self.btnOtherResourcesPositionY_Constraint.constant += toBeMoved;
        self.btnReportAdverseEffectPositionY_Constraint.constant += toBeMoved;
    }
}

-(void) displayDifferentImage
{
    NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
    
    if (password == nil)
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgReminder setImage:[UIImage imageNamed:@"bm_btn_reminders_inactive"]];
            [imgVaccinationTracker setImage:[UIImage imageNamed:@"bm_btn_vaccinationtracker_inactive"]];
        }
        else
        {
            [imgReminder setImage:[UIImage imageNamed:@"btn_reminders_inactive"]];
            [imgVaccinationTracker setImage:[UIImage imageNamed:@"btn_vaccinationtracker_inactive"]];
            [imgReportAdverseEffect setImage:[UIImage imageNamed:@"btn_reportadverseeffect_inactive"]];
        }
    }
}

-(void) changeLockIconStatus
{
    NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
    
    if (password != nil)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    }
}

-(void) logout
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    // destroy password(id)
    [SSKeychain deletePasswordForService:@"myVac4Baby" account:@"anyUser"];
    
    // reset child arr
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"childArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Logged Out")
                                                      message:LocalizedString(@"You have successfully logged out. You will still receive push notifications for your registered children.") delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
    
    [SVProgressHUD dismiss];
    
    loginView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (void)showAlert1:(UITapGestureRecognizer *)sender
{
    // check if user login
    NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
    
    if (password == nil)
    { return; }
    
    // reminderVC
    
    reminderView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"reminderVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (void)showAlert2:(UITapGestureRecognizer *)sender
{
    // videoVC
    
    videoView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"videoVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (void)showAlert3:(UITapGestureRecognizer *)sender
{
   // resourcesVC
    
    otherResourcesView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"resourcesVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (void)showAlert4:(UITapGestureRecognizer *)sender
{
    // check if user login
    NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
    
    if (password == nil)
    { return; }
    
    // trackerVC
    
    vaccinationTrackerView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"trackerVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (void)showAlert5:(UITapGestureRecognizer *)sender
{
    // vpdVC
    
    vaccinePreventableDiseaseView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"vpdVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (void)showAlert6:(UITapGestureRecognizer *)sender
{
    // check if user login
    NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
    
    if (password == nil)
    { return; }
    
   // reportVC
    
    reportAdverseEffectView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"reportVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
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

- (IBAction)loginView:(id)sender {
        
    // loginVC
    
    loginView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

@end
