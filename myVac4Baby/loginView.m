//
//  loginView.m
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "loginView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface loginView ()

@end

@implementation loginView

@synthesize revealLeftMenu;
@synthesize txtUsername, txtPassword, btnForgotPassword;
@synthesize lblUsername, lblPassword, btnRegistration, btnLogin;
@synthesize imgLogo;
@synthesize scrollCustomHeight;
@synthesize viewCustomHeight;
@synthesize lblUsernameConstantFromLogo, logoConstantToBottom;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor yellowColor];
    
    [self keyboardToolbarSetup];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    notificationArr = [[NSMutableArray alloc] init];
    
    // [self testCode];
}

-(void)dismissKeyboard {

    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    [self setUpView];
    
    self.revealViewController.delegate = (id)self;
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

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    { LocalizationSetLanguage(@"en"); }
    else
    {
        [imgLogo setImage:[UIImage imageNamed:@"bm_logo_3"]];
        [btnForgotPassword setTitle:@"Terlupa kata laluan?" forState:UIControlStateNormal];
        LocalizationSetLanguage(@"ms");
    }
    
    [lblUsername setText:LocalizedString(@"Username")];
    [lblPassword setText:LocalizedString(@"Password")];
    [txtUsername setPlaceholder:LocalizedString(@"Username")];
    [txtPassword setPlaceholder:LocalizedString(@"Password")];
    self.title = LocalizedString(@"Welcome");
    [btnRegistration setTitle:LocalizedString(@"New here? Register now!") forState:UIControlStateNormal];
    [btnLogin setTitle:LocalizedString(@"Login") forState:UIControlStateNormal];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.widthSizeConstraint.constant = screenWidth;
    
    txtPassword.secureTextEntry = YES;
    
    txtUsername.delegate = (id)self;
    txtPassword.delegate = (id)self;
    
    txtUsername.nextTextField = txtPassword;
    
    CGFloat screenHeight = screenRect.size.height;
    
    scrollCustomHeight.constant = screenHeight;
    viewCustomHeight.constant = screenHeight;
    
    if(screenHeight == 667)
    {
        /* increase constant in iphone 6 */
        
        logoConstantToBottom.constant = 90;
        lblUsernameConstantFromLogo.constant = 90;
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

- (IBAction)skip:(id)sender
{
    mainMenuView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (IBAction)forgetPassword:(id)sender
{
    // [self testCode];
    
    [self performSegueWithIdentifier:@"forgetPasswordSegue" sender:nil];
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
    NSString *currentDate = [NSString stringWithFormat:@"2015-02-16 00:33:00"];
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

- (IBAction)login:(id)sender {
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    if([txtUsername.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Oops! Looks like you forgot to enter your username.") :@"Unable to Login"];
        
        return;
    }
    
    if([txtUsername.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Username should not be more than 20 characters") :@"Error"];
        
        return;
    }
    
    if([txtPassword.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Oops! Looks like you forgot to enter your password.") :@"Unable to Login"];
        
        return;
    }
    
    if([txtPassword.text length] > 200)
    {
        [self showMessage:LocalizedString(@"Password should not be more than 200 characters") :@"Error"];
        
        return;
    }
    
    [self proceedLogin];
}

-(void) proceedLogin
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    login *request = [[login alloc] init_login:txtUsername.text ipassword:txtPassword.text];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"login"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                // set username
                [[NSUserDefaults standardUserDefaults] setObject:txtUsername.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // set login session
                [SSKeychain setPassword:[[responseMessage objectForKey:@"data"] objectForKey:@"momId"] forService:@"myVac4Baby" account:@"anyUser"];
                                
                [self getChilds];
            }
            else
            {
                // set different language display text
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {     LocalizationSetLanguage(@"en"); }
                else
                {  LocalizationSetLanguage(@"ms"); }
                
                [self showMessage:LocalizedString(@"Username or password that you have entered is incorrect") :@"Unable to Login"];
            }
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getChildByMomId"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                NSMutableArray *localArr = [[NSMutableArray alloc] init];
                
                NSArray *tempArr = [responseMessage objectForKey:@"data"];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"type", [[tempArr objectAtIndex:i] objectForKey:@"child_name"], @"name", [[tempArr objectAtIndex:i] objectForKey:@"child_image"], @"url", [[tempArr objectAtIndex:i] objectForKey:@"child_id"], @"childId", [[tempArr objectAtIndex:i] objectForKey:@"child_gender"], @"gender", [[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"], @"dob",nil];
                                                            
                    [localArr addObject:dict];
                }
                
                // set child object
                [[NSUserDefaults standardUserDefaults] setObject:localArr forKey:@"childArr"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // check if loggedInMomId is empty
                
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInMomId"] == nil)
                {
                    // when loggedInMomId is nil (first time), save mom id, no need to compare
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"] forKey:@"loggedInMomId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSLog(@"nil - mom id");
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        // create notification all over again
                        
                        for(int i = 0; i < tempArr.count; i++)
                        {
                            [self createFirstNotifications:[[tempArr objectAtIndex:i] objectForKey:@"child_id"] ichildImageUrl:[[tempArr objectAtIndex:i] objectForKey:@"child_image"] ibday:[[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"] iname:[[tempArr objectAtIndex:i] objectForKey:@"child_name"]];
                            
                            [self createSecondNotifications:[[tempArr objectAtIndex:i] objectForKey:@"child_id"] ichildImageUrl:[[tempArr objectAtIndex:i] objectForKey:@"child_image"] ibday:[[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"] iName:[[tempArr objectAtIndex:i] objectForKey:@"child_name"]];
                            
                            // delete all previous notifications
                            // only then insert new notifications
                            latestNotification *dbNotification = [[latestNotification alloc] init];
                            [dbNotification deleteNotificationsByChildId:[[tempArr objectAtIndex:i] objectForKey:@"child_id"]];
                            [dbNotification insertLatestNotificationsInOneTime:notificationArr];
                            
                            
                        }
                    });
                }
                else
                {
                    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInMomId"] isEqualToString:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"]])
                    {
                        // if logged in mom id is the same with previous mom id, do nothing
                        
                        NSLog(@"same mom id");
                    }
                    else
                    {
                        // different mom
                        
                        [self clearPreviousReminders];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"] forKey:@"loggedInMomId"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            // create notification all over again
                            
                            for(int i = 0; i < tempArr.count; i++)
                            {
                                 [self createFirstNotifications:[[tempArr objectAtIndex:i] objectForKey:@"child_id"] ichildImageUrl:[[tempArr objectAtIndex:i] objectForKey:@"child_image"] ibday:[[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"] iname:[[tempArr objectAtIndex:i] objectForKey:@"child_name"]];
                                 
                                 [self createSecondNotifications:[[tempArr objectAtIndex:i] objectForKey:@"child_id"] ichildImageUrl:[[tempArr objectAtIndex:i] objectForKey:@"child_image"] ibday:[[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"] iName:[[tempArr objectAtIndex:i] objectForKey:@"child_name"]];
                                
                                // delete all previous notifications
                                // only then insert new notifications
                                latestNotification *dbNotification = [[latestNotification alloc] init];
                                [dbNotification deleteNotificationsByChildId:[[tempArr objectAtIndex:i] objectForKey:@"child_id"]];
                                [dbNotification insertLatestNotificationsInOneTime:notificationArr];
                            }
                        });
                    }
                }
            }
            else
            {
                [self clearPreviousReminders];
            }
            
            // navigate to main view
            mainMenuView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
            [self.navigationController pushViewController:mmvc animated:YES];
        }
    }
    
    [SVProgressHUD dismiss];
}

-(void) clearPreviousReminders
{
    // remove all previous local notification (reminder)
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    if([eventArray count] != 0)
    { [[UIApplication sharedApplication] cancelAllLocalNotifications]; }
    
    // remove all badge
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"receivedReminder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // clear previous local notification (reminder) detail
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"3" forKey:@"pushNotificationType"];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"notificationDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) getChilds
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getChilds *request = [[getChilds alloc] init_getChilds:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) showMessage :(NSString*)msg :(NSString*) title
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(title)
                                                      message:msg delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
    
    [SVProgressHUD dismiss];
}

- (IBAction)registration:(id)sender {
    
    // registrationVC
    
    registrationView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"registrationVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

-(void) createFirstNotifications :(NSString*) childId ichildImageUrl:(NSString*)childImageUrl ibday:(NSString*) strDOB iname:(NSString*) childName
{
    // get all first notifications details
    firstNotification *notification = [[firstNotification alloc] init];
    NSArray *allFirstNotifications;
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        LocalizationSetLanguage(@"en");
        allFirstNotifications = [notification retrieveAllFirstNotifications];
    }
    else
    {
        LocalizationSetLanguage(@"ms");
        allFirstNotifications = [notification retrieveAllFirstNotifications_ms];
    }
    
    // date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSDateComponents *dateComponents;
    
    // child's birthday
    // NSString *currentDate = @"2014-11-29 13:10:00";
    NSString *currentDate = [NSString stringWithFormat:@"%@ 08:00:00", strDOB];
    NSDate *dt = [dateFormatter dateFromString:currentDate];
    
    int addDaysCount = 0;
    NSDate *dummyDate;
    
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [dateformate stringFromDate:[NSDate date]];
    NSString *localNotificationFireDate;
    
    NSString *pre_msg = LocalizedString(@"Vaccination Reminder for");
    NSString *msg = [NSString stringWithFormat:@"%@ %@", pre_msg, childName];
    
    NSLog(@"baby bday : %@", dt);
    
    // create 10 2nd notifications
    
    for (int i = 0; i < allFirstNotifications.count; i++)
    {
        // bizFirstNotification *biz = [allFirstNotifications objectAtIndex:i];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setValue:childId forKey:@"childId"];
        [dict setValue:[NSString stringWithFormat:@"%d", i+1] forKey:@"pushNotificationId"];
        [dict setValue:childImageUrl forKey:@"childImgUrl"];
        [dict setValue:@"1" forKey:@"pushNotificationType"];
        
        // NSLog(@"dict : %@", dict);
        
        // calculate notification fire date
        
        switch (i) {
            case 0:
                
                // at birth - add 1 week
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 7;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"at birth : %@", dummyDate);
                
                break;
            case 1:
                
                // 1 month - add 1 month
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:1];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"1 month : %@", dummyDate);
                
                break;
            case 2:
                
                // 2 months - add 2 months
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:2];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"2 months : %@", dummyDate);
                
                break;
            case 3:
                
                // 3 months - add 3 months
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:3];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"3 months : %@", dummyDate);
                
                break;
            case 4:
                
                // 5 months - add 5 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:5];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"5 months : %@", dummyDate);
                
                break;
            case 5:
                
                // 6 months - add 6 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:6];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"6 months : %@", dummyDate);
                
                break;
            case 6:
                
                // 9 months - add 9 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:9];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"9 months : %@", dummyDate);
                
                break;
            case 7:
                
                // 12 months - add 12 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:12];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"12 months : %@", dummyDate);
                
                break;
            case 8:
                
                // 18 months - add 18 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:18];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"18 months : %@", dummyDate);
                
                break;
            case 9:
                
                // 21 months - add 21 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:21];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"21 months : %@", dummyDate);
                
                break;
            case 10:
                
                // 24 months - add 24 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:24];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"24 months : %@", dummyDate);
                
                break;
            default:
                break;
        }
        
        // only scehdule reminder where fire date is > than today date
        localNotificationFireDate = [dateformate stringFromDate:dummyDate];
        
        if([todayDate compare:localNotificationFireDate] == NSOrderedDescending)
        {
            continue;
        }
        
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = dummyDate;
        
        NSLog(@"fire date : %@", localNotification.fireDate);
        
        // different based on the notifications title
        localNotification.alertBody = msg;
        
        localNotification.alertAction = @"VaksinBaby";
        
        localNotification.userInfo = dict;
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        // add dict into notification arr for insertion of data later
        [dict setValue:[dateformate stringFromDate:dummyDate] forKey:@"pushNotificationDate"];
        [notificationArr addObject:dict];
    }
    
    NSLog(@"done");
}


-(void) createSecondNotifications:(NSString*) childId ichildImageUrl:(NSString*)childImageUrl ibday:(NSString*) strDOB iName:(NSString*) childName
{
    // date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSDateComponents *dateComponents;
    
    // child's birthday
    // NSString *currentDate = @"2014-11-29 13:10:00";
    NSString *currentDate = [NSString stringWithFormat:@"%@ 08:00:00", strDOB];
    NSDate *dt = [dateFormatter dateFromString:currentDate];
    
    int addDaysCount = 0;
    NSDate *dummyDate;
    
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [dateformate stringFromDate:[NSDate date]];
    NSString *localNotificationFireDate;
    
    NSString *pre_msg = LocalizedString(@"Please update Vaccination Tracker for");
    NSString *msg = [NSString stringWithFormat:@"%@ %@", pre_msg, childName];
    
    NSLog(@"baby bday : %@", dt);
    
    // create 10 2nd notifications
    
    for(int i = 0; i < 10; i++)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setValue:childId forKey:@"childId"];
        [dict setValue:[NSString stringWithFormat:@"%d", i+1] forKey:@"pushNotificationId"];
        [dict setValue:childImageUrl forKey:@"childImgUrl"];
        [dict setValue:@"2" forKey:@"pushNotificationType"];
        
        // NSLog(@"dict : %@", dict);
        
        // calculate notification fire date
        
        switch (i) {
            case 0:
                
                // at birth - add 1 week + 28 days
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 35;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"at birth : %@", dummyDate);
                
                break;
            case 1:
                
                // 1 month - add 1 month + 28 days
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:1];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"1 month : %@", dummyDate);
                
                break;
            case 2:
                
                // 2 months - add 2 months + 28 days
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:2];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"2 months : %@", dummyDate);
                
                break;
            case 3:
                
                // 3 months - add 3 months + 28 days
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:3];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"3 months : %@", dummyDate);
                
                break;
            case 4:
                
                // 5 months - add 5 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:5];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"5 months : %@", dummyDate);
                
                break;
            case 5:
                
                // 6 months - add 6 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:6];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"6 months : %@", dummyDate);
                
                break;
            case 6:
                
                // 9 months - add 9 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:9];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"9 months : %@", dummyDate);
                
                break;
            case 7:
                
                // 12 months - add 12 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:12];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"12 months : %@", dummyDate);
                
                break;
            case 8:
                
                // 18 months - add 18 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:18];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"18 months : %@", dummyDate);
                
                break;
            case 9:
                
                // 21 months - add 21 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:21];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"21 months : %@", dummyDate);
                
                break;
                
            default:
                break;
        }
        
        // only scehdule reminder where fire date is > than today date
        localNotificationFireDate = [dateformate stringFromDate:dummyDate];
        
        if([todayDate compare:localNotificationFireDate] == NSOrderedDescending)
        {
            continue;
        }
        
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = dummyDate;
        
        NSLog(@"fire date : %@", localNotification.fireDate);
        
        localNotification.alertBody = msg;
        
        localNotification.alertAction = @"VaksinBaby";
        
        localNotification.userInfo = dict;
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        // add dict into notification arr for insertion of data later
        [dict setValue:[dateformate stringFromDate:dummyDate] forKey:@"pushNotificationDate"];
        [notificationArr addObject:dict];
    }
    
    NSLog(@"done");
}

- (void) keyboardToolbarSetup
{
    if(self.keyboardToolbar == nil)
    {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *preButton = [[UIBarButtonItem alloc] initWithTitle:@"<  " style:UIBarButtonItemStylePlain target:self action:@selector(moveToPrevTextfield)];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"  >" style:UIBarButtonItemStylePlain target:self action:@selector(moveToNextTextfield)];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
        
        NSArray *toolbarButtons = [[NSArray alloc]initWithObjects:preButton, nextButton, extraSpace, doneButton, nil];
        
        [self.keyboardToolbar setItems:toolbarButtons];
        
        txtUsername.inputAccessoryView = self.keyboardToolbar;
        txtPassword.inputAccessoryView = self.keyboardToolbar;
    }
}

-(void) moveToPrevTextfield
{
    if(txtUsername.isFirstResponder){ [txtUsername resignFirstResponder]; }
    else if(txtPassword.isFirstResponder){ [txtPassword resignFirstResponder]; [txtUsername becomeFirstResponder]; }
}

-(void) moveToNextTextfield
{
    if(txtUsername.isFirstResponder){ [txtUsername resignFirstResponder]; [txtPassword becomeFirstResponder]; }
    else if(txtPassword.isFirstResponder){ [txtPassword resignFirstResponder]; }
}

-(void) doneAction
{
    /* remove the keyboard from view */
    
    [self dismissKeyboard];
}

-(void) moveScreenUp: (UITextField *)textField
{
    CGRect textFieldRect = [self.view convertRect:textField.bounds fromView:textField];
    
    CGRect viewRect = [self.view convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        // ipad
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
        if(animatedDistance < 150)
        {
            // ipod touch
            animatedDistance = animatedDistance / 3;
        }
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void) moveScreenDown
{
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveScreenUp:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveScreenDown];
}

@end
