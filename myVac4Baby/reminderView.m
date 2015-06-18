//
//  reminderView.m
//  myVac4Baby
//
//  Created by jun on 10/31/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "reminderView.h"

@interface reminderView ()

@end

@implementation reminderView

@synthesize revealLeftMenu;
@synthesize lblRegisterText;
@synthesize btnAddChild;
@synthesize tblChild;
@synthesize childArr;
@synthesize registerView;
@synthesize reminderView_, monthArr;
@synthesize tbl2ndNotification;
@synthesize lblBubbleTitle, lblBubbleDetail;
@synthesize registerScrollView;
@synthesize secondNotificationView;
@synthesize firstNotificationView;
@synthesize lblBubbleTitle1st, lblBubbleDetail1st;
@synthesize imgSecondNotificationChild, imgFirstNotificationChild;
@synthesize tblNIP, nipArr;
@synthesize webView, lblNA;
@synthesize imgNoReminder;
@synthesize lblAC, lblNIP;
@synthesize btnAddChildFromBottom;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(proceedExecution) withObject:nil afterDelay:1];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"autoReminder_receiveNotification"])
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

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) proceedExecution
{
    [self callAPI];
    
    /*imgCounter = 0;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"receivedReminder"])
    {
        [registerView setAlpha:0];
        [reminderView_ setAlpha:1];
        [registerScrollView setAlpha:0];
        
        [self setUpReminderNotification];
        
        imgCounter++;
    }
    else
    {
        [self callAPI];
    }
     */
}

-(void) setUpReminderNotification
{
    [imgNoReminder setAlpha:0];
    
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationType"] intValue] == 1)
    {
        [firstNotificationView setAlpha:1];
        [self setUpReminderTable_1stNotification];
        [self changeNIP_AC_img];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"receivedReminder"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationType"] intValue] == 2)
    {
        [secondNotificationView setAlpha:1];
        [self setUpReminderTable1_2ndNotification];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"receivedReminder"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgNoReminder setImage:[UIImage imageNamed:@"bm_default_noreminder"]];
        }
        
        [imgNoReminder setAlpha:1];
    }
}

-(void) changeNIP_AC_img
{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [lblNIP setImage:[UIImage imageNamed:@"bm_label_nationalimmunisationprogramme"]];
        [lblAC setImage:[UIImage imageNamed:@"bm_label_additionalvaccines_horizontal"]];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    [self setUpView];
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"autoReminder";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"autoReminder_receiveNotification"
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

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    lblRegisterText.text = LocalizedString(@"Register your child to get auto reminders of your child’s vaccines");
    
    self.navigationItem.title = LocalizedString(@"Auto Reminders");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.registerContentWidthConstraint.constant = screenWidth;
    
    if(screenWidth < 760)
    {
        self.secondNotificationTableWidthConstraint.constant = screenWidth;
        self.notificationSecondContentWidthConstraint.constant = screenWidth;
        
        self.firstNotificationViewWidthConstraint.constant = screenWidth;
    }
    
    // imgBaby_Reminder.layer.cornerRadius = imgBaby_Reminder.frame.size.height / 2;
    // imgBaby_Reminder.layer.masksToBounds = YES;
    // imgBaby_Reminder.layer.borderWidth = 0;
}

-(void) callAPI
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    // get childs
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getChilds *request = [[getChilds alloc] init_getChilds:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if(tableView == tblChild)
    {
        return [childArr count];
    }
    else if(tableView == tbl2ndNotification)
    {
        return [monthArr count];
    }
    else
    {
        return [nipArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // notification2ndCell
    static NSString *CellIdentifier;
    
    if(tableView == tblChild)
    {
        CellIdentifier = @"childCell";
    }
    else if(tableView == tbl2ndNotification)
    {
        CellIdentifier = @"notification2ndCell";
    }
    else if(tableView == tblNIP)
    {
        CellIdentifier = @"notification1stCell";
    }
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(tableView == tblChild)
    {
        bizChild *child = [childArr objectAtIndex:indexPath.row];
    
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:child.childName];
    
        UIImageView *imgBg = (UIImageView*)[cell viewWithTag:2];
    
        if( [child.childGender caseInsensitiveCompare:@"male"] == NSOrderedSame )
        {
            [imgBg setImage:[UIImage imageNamed:@"vaccinationtracker_boy"]];
        }
        else
        {
            [imgBg setImage:[UIImage imageNamed:@"vaccinationtracker_girl"]];
        }
    
        UIImageView *imgBaby = (UIImageView*)[cell viewWithTag:3];
        imgBaby.layer.cornerRadius = imgBaby.frame.size.height / 2;
        imgBaby.layer.masksToBounds = YES;
        imgBaby.layer.borderWidth = 1.0f;
        imgBaby.layer.borderColor = [UIColor whiteColor].CGColor;
        imgBaby.clipsToBounds = YES;
        imgBaby.contentMode = UIViewContentModeCenter;
        imgBaby.contentMode = UIViewContentModeScaleAspectFit;
        
        [imgBaby setImageWithURL:[NSURL URLWithString:child.childImageUrl]  placeholderImage:[UIImage imageNamed:@"default_addaphotoofyourbaby"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
       
            if(error){ NSLog(@"get child photo : error"); }
        }];
    }
    else if(tableView == tbl2ndNotification)
    {
        bizReminderSecondNotificationMonth *obj = [monthArr objectAtIndex:indexPath.row];

        UIImageView *imgMonth = (UIImageView*)[cell viewWithTag:1];
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {  [imgMonth setImage:[UIImage imageNamed:[self get2ndNotificationImage_en:obj.month]]]; }
        else{  [imgMonth setImage:[UIImage imageNamed:[self get2ndNotificationImage_ms:obj.month]]]; }
        
        UIImageView *imgNotification = (UIImageView*)[cell viewWithTag:2];
        
        if(indexPath.row == (monthArr.count-1))
        { [imgNotification setAlpha:1]; }
        else{ [imgNotification setAlpha:0]; }
    }
    else if(tableView == tblNIP)
    {
        bizReminderFirstNotificationNip *nip = [nipArr objectAtIndex:indexPath.row];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:nip.nipTitle];
        
        UIImageView *imgFrontBaby = (UIImageView*)[cell viewWithTag:2];
        
        if(indexPath.row + 1 == [nipArr count])
        {
            [imgFrontBaby setImage:[UIImage imageNamed:@"icon_vaccine_2"]];
        }
        else
        {
            [imgFrontBaby setImage:[UIImage imageNamed:@"icon_vaccine_1"]];
        }
    }
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index path : %d", indexPath.row);
    
    if(tableView == tbl2ndNotification)
    {
        selectedMonthIndex = indexPath.row;
        
        [self performSegueWithIdentifier:@"vaccineReminderDetailSegue" sender:nil];
    }
    else if(tableView == tblChild)
    {
        selectedChildIndex = indexPath.row;
        
        [self performSegueWithIdentifier:@"notificationSegue" sender:nil];
    }
    else if(tableView == tblNIP)
    {        
        selectedNipIndex = indexPath.row;
        
        [self performSegueWithIdentifier:@"nipSegue" sender:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == tblChild)
    {
        return 80.0f;
    }
    else if(tableView == tbl2ndNotification)
    {
        return 49.0f;
    }
    else
    {
        return 40.0f;
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

- (IBAction)home:(id)sender {
    
    mainMenuView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}

- (IBAction)createChild:(id)sender {
    
    [self performSegueWithIdentifier:@"createChildSegue" sender:nil];
}

-(void) setUpReminderTable_1stNotification
{
    [self getFirstNotificationData];   
}

-(void) getFirstNotificationData
{
    firstNotification *notification = [[firstNotification alloc] init];
    
    NSArray *arr;
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        LocalizationSetLanguage(@"en");
        
        arr = [notification retrieveFirstNotificationById:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationId"]];
    }
    else
    {
        LocalizationSetLanguage(@"ms");
        
        arr = [notification retrieveFirstNotificationById_ms:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationId"]];
    }
    
    if([arr count] > 0)
    {
        bizFirstNotification *biz = [arr objectAtIndex:0];
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:biz.notificationTitle];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributeString length]}];
        
        [lblBubbleTitle1st setAttributedText:attributeString];
        
        [lblBubbleDetail1st setText:LocalizedString(@"\" Mummy,\n please remember my vaccination this month. \"")];
        
        [imgFirstNotificationChild setImageWithURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]] placeholderImage:[UIImage imageNamed:@"default_1streminder_child.png"]];
        imgFirstNotificationChild.layer.cornerRadius = imgFirstNotificationChild.frame.size.height / 2;
        imgFirstNotificationChild.layer.masksToBounds = YES;
        imgFirstNotificationChild.layer.borderWidth = 0;
        
        nipArr = [[NSMutableArray alloc] init];
        
        NSArray *titleArr = [biz.vaccineTitle componentsSeparatedByString:@";"];
        NSArray *idArr = [biz.fkVaccinePreventableDiseaseId componentsSeparatedByString:@";"];
        NSArray *urlArr = [biz.preventableDiseaseDescUrl componentsSeparatedByString:@";"];
        
        for(int i = 0; i < titleArr.count; i++)
        {
            bizReminderFirstNotificationNip *nip = [[bizReminderFirstNotificationNip alloc] init];
            
            [nip setNipId:[idArr objectAtIndex:i]];
            [nip setNipTitle:[titleArr objectAtIndex:i]];
            [nip setNipUrl:[urlArr objectAtIndex:i]];
            
            [nipArr addObject:nip];
        }
        
        if(biz.notificationDescUrl != nil){
            
            NSString *fullURL = [NSString stringWithFormat:@"%@", biz.notificationDescUrl];
            NSURL *url = [NSURL URLWithString:fullURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            
            [webView setScalesPageToFit:YES];
            [webView loadRequest:requestObj];
            
            [webView setAlpha:1];
        }
        else
        {
            [lblNA setAlpha:1];
        }
    }
    
    [self updateFirstNotificationTableHeight:nipArr.count];
    
    [tblNIP reloadData];
}

-(void) updateFirstNotificationTableHeight :(int) count
{
    self.tblNipHeightConstraint.constant = 40;
    self.firstNotificationViewHeightConstraint.constant = 470;
    
    // add 45.0f for extra 1
    
    int extra = count - 1;
    
    if(extra > 0)
    {
        int additon = extra * 45;
        
        self.tblNipHeightConstraint.constant += additon - 3;
        
        self.firstNotificationViewHeightConstraint.constant += additon;
    }
}

-(void) setUpReminderTable1_2ndNotification
{
    if(monthArr.count > 0){ return; }
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"VACCINATION TRACKER UPDATES :")];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                value:[NSNumber numberWithInt:1]
                    range:(NSRange){0,[attributeString length]}];
    
    [lblBubbleTitle setAttributedText:attributeString];
    
    [lblBubbleDetail setText:LocalizedString(@"\" Mummy,\n please remember to update my Vaccination Tracker. \"")];
    
    // loop throught the list of child and get the child's latest image
    NSArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"childArr"];
    NSString *childImg = [[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"];
    
    for(int i = 0; i < temp.count; i++)
    {
        if([[[temp objectAtIndex:i] objectForKey:@"childId"] intValue] == [[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"] intValue])
        {
            childImg = [[temp objectAtIndex:i] objectForKey:@"url"];
            break;
        }
    }
    
    [imgSecondNotificationChild setImageWithURL:[NSURL URLWithString:childImg] placeholderImage:[UIImage imageNamed:@"default_1streminder_child.png"]];
    imgSecondNotificationChild.layer.cornerRadius = imgSecondNotificationChild.frame.size.height / 2;
    imgSecondNotificationChild.layer.masksToBounds = YES;
    imgSecondNotificationChild.layer.borderWidth = 0;
    
    monthArr = [[NSMutableArray alloc] init];
    
    [self getSecondNotificationData];
    
    [self updateSecondNotificationTableHeight:monthArr.count];
    
    [tbl2ndNotification reloadData];
}

-(void) getSecondNotificationData
{
    secondNotification *notification = [[secondNotification alloc] init];
    
    NSArray *arr;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        arr = [notification retrieveSecondNotificationById:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationId"]];
    }
    else
    {
        arr = [notification retrieveSecondNotificationById_ms:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationId"]];
    }
    
    NSLog(@"~~");
    
    if([arr count] > 0)
    {
        bizSecondNotification *biz = [arr objectAtIndex:0];
        
        NSArray *months = [biz.vaccineTimes componentsSeparatedByString:@";"];
        
        NSError *e;
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [biz.fkVaccineIds dataUsingEncoding:NSUTF8StringEncoding]  options: NSJSONReadingMutableContainers error: &e];
        
        for(int i = 0; i < months.count; i++)
        {
            bizReminderSecondNotificationMonth *obj = [[bizReminderSecondNotificationMonth alloc] init];

            [obj setMonth:[months objectAtIndex:i]];
            [obj setVaccineIds:[JSON objectForKey:[months objectAtIndex:i]]];
            
            [monthArr addObject:obj];
        }
    }
}

-(void) updateSecondNotificationTableHeight :(int) count
{
    // add 49.0f for extra 1
    
    int extra = count - 4;
    
    if(extra > 0)
    {
        int additon = extra * 49;
        
        self.tblSecondNotificationHeight.constant += additon - 30;
        
        self.notificationSecondHeightConstraint.constant += additon;
    }
}

-(NSString*) get2ndNotificationImage_en :(NSString*)monthName
{
    NSString *strImgName = @"";
    
    // base on language selection
    
    if([monthName isEqualToString:@"At Birth"])
    {
        strImgName = @"vaccine_atbirth";
    }
    else if([monthName isEqualToString:@"1 Month"])
    {
        strImgName = @"vaccine_1months";
    }
    else if([monthName isEqualToString:@"2 Month"])
    {
        strImgName = @"vaccine_2months";
    }
    else if([monthName isEqualToString:@"3 Month"])
    {
        strImgName = @"vaccine_3months";
    }
    else if([monthName isEqualToString:@"5 Month"])
    {
        strImgName = @"vaccine_5months";
    }
    else if([monthName isEqualToString:@"6 Month"])
    {
        strImgName = @"vaccine_6months";
    }
    else if([monthName isEqualToString:@"9 Month"])
    {
        strImgName = @"vaccine_9months";
    }
    else if([monthName isEqualToString:@"12 Month"])
    {
        strImgName = @"vaccine_12months";
    }
    else if([monthName isEqualToString:@"18 Month"])
    {
        strImgName = @"vaccine_18months";
    }
    else if([monthName isEqualToString:@"21 Month"])
    {
        strImgName = @"vaccine_21months";
    }
    else if([monthName isEqualToString:@"24 Month"])
    {
        strImgName = @"vaccine_24months";
    }

    return strImgName;
}

-(NSString*) get2ndNotificationImage_ms :(NSString*)monthName
{
    NSString *strImgName = @"";
    
    // base on language selection
    // month name will be in malay if not mistaken
    
    if([monthName isEqualToString:@"Ketika Lahir"])
    {
        strImgName = @"bm_vaccine_atbirth";
    }
    else if([monthName isEqualToString:@"1 Bulan"])
    {
        strImgName = @"bm_vaccine_1months";
    }
    else if([monthName isEqualToString:@"2 Bulan"])
    {
        strImgName = @"bm_vaccine_2months";
    }
    else if([monthName isEqualToString:@"3 Bulan"])
    {
        strImgName = @"bm_vaccine_3months";
    }
    else if([monthName isEqualToString:@"5 Bulan"])
    {
        strImgName = @"bm_vaccine_5months";
    }
    else if([monthName isEqualToString:@"6 Bulan"])
    {
        strImgName = @"vaccine_6months";
    }
    else if([monthName isEqualToString:@"9 Bulan"])
    {
        strImgName = @"bm_vaccine_9months";
    }
    else if([monthName isEqualToString:@"12 Bulan"])
    {
        strImgName = @"bm_vaccine_12months";
    }
    else if([monthName isEqualToString:@"18 Bulan"])
    {
        strImgName = @"bm_vaccine_18months";
    }
    else if([monthName isEqualToString:@"21 Bulan"])
    {
        strImgName = @"bm_vaccine_21months";
    }
    else if([monthName isEqualToString:@"24 Bulan"])
    {
        strImgName = @"bm_vaccine_24months";
    }
    
    return strImgName;
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getChildByMomId"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                childArr = [[NSMutableArray alloc] init];
                
                NSArray *tempArr = [responseMessage objectForKey:@"data"];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    bizChild *child = [[bizChild alloc] init];
                    [child setChildId:[[tempArr objectAtIndex:i] objectForKey:@"child_id"]];
                    [child setChildName:[[tempArr objectAtIndex:i] objectForKey:@"child_name"]];
                    [child setChildGender:[[tempArr objectAtIndex:i] objectForKey:@"child_gender"]];
                    [child setChildDateOfBirth:[[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"]];
                    [child setChildImageUrl:[[tempArr objectAtIndex:i] objectForKey:@"child_image"]];
                    
                    [childArr addObject:child];
                }
                
                // re-set child arr
                NSMutableArray *localArr = [[NSMutableArray alloc] init];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"type", [[tempArr objectAtIndex:i] objectForKey:@"child_name"], @"name", [[tempArr objectAtIndex:i] objectForKey:@"child_image"], @"url", [[tempArr objectAtIndex:i] objectForKey:@"child_id"], @"childId", [[tempArr objectAtIndex:i] objectForKey:@"child_gender"], @"gender", [[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"], @"dob",nil];
                    
                    [localArr addObject:dict];
                }
                
                // set child object
                [[NSUserDefaults standardUserDefaults] setObject:localArr forKey:@"childArr"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                [self updateRegisterViewConstraint:tempArr.count];

                [btnAddChild setTitle:LocalizedString(@"Add Child") forState:UIControlStateNormal];
                
                [tblChild reloadData];
            }
            else
            {
                [btnAddChild setTitle:LocalizedString(@"Add Child") forState:UIControlStateNormal];
                
                [self updateRegisterViewConstraint:0];
            }
        
            [btnAddChild setAlpha:1];
        }
    }
    
    [SVProgressHUD dismiss];
}

-(void) updateRegisterViewConstraint :(int) count
{
    // add 77.0f for extra 1
    
    int extra = count - 1;
    
    if(extra > 0)
    {
        int additon = extra * 77;
        
        self.registerTblChildHeight.constant += additon;
        
        self.registerContentHeightConstraint.constant += (additon - 100);
    }
    else
    {
        /* adjust the position of add child button from view's bottom edge */
        
        btnAddChildFromBottom.constant = 170;
        
        int substraction = (extra * -1) * 77;
        
        btnAddChildFromBottom.constant += substraction;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"notificationSegue"])
    {
        notificationView *SegueController = (notificationView*)[segue destinationViewController];
        SegueController.child_passBy = [childArr objectAtIndex:selectedChildIndex];
    }
    else if([[segue identifier]isEqualToString:@"gotoNotificationSegue"])
    {
        bizChild *child = [[bizChild alloc] init];
        [child setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        notificationView *SegueController = (notificationView*)[segue destinationViewController];
        SegueController.child_passBy = child;
    }
    
    /*
    if([[segue identifier]isEqualToString:@"vaccineReminderDetailSegue"])
    {
        // notification details
        
        bizChild *child = [[bizChild alloc] init];
        [child setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        // loop throught the list of child and get the child's name
        NSArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"childArr"];
        
        for(int i = 0; i < temp.count; i++)
        {
            if([[[temp objectAtIndex:i] objectForKey:@"childId"] intValue] == [child.childId intValue])
            {
               [child setChildName:[[temp objectAtIndex:i] objectForKey:@"name"]];
                break;
            }
        }
        
        vaccinationDetailReminderView *SegueController = (vaccinationDetailReminderView*)[segue destinationViewController];
        SegueController.obj = [monthArr objectAtIndex:selectedMonthIndex];
        SegueController.child = child;
    }
    else if([[segue identifier]isEqualToString:@"vtDetailSegue"])
    {
        vaccinationTrackerDetailView *SegueController = (vaccinationTrackerDetailView*)[segue destinationViewController];
        SegueController.child = [childArr objectAtIndex:selectedChildIndex];
    }
    else if([[segue identifier]isEqualToString:@"nipSegue"])
    {
        nipDetailView *SegueController = (nipDetailView*)[segue destinationViewController];
        SegueController.nip = [nipArr objectAtIndex:selectedNipIndex];
    }
    */
}

/*
 - (IBAction)changeImg:(id)sender {
 
 if(imgCounter % 2 == 0)
 {
 [registerView setAlpha:0];
 [reminderView_ setAlpha:1];
 [registerScrollView setAlpha:0];
 
 // show the last notification
 
 // determine if the notification is belong to current mom
 // if YES, show it
 // if NO, do not show it, show the image instead
 
 [self setUpReminderNotification];
 }
 else
 {
 [registerView setAlpha:1];
 [reminderView_ setAlpha:0];
 [registerScrollView setAlpha:1];
 [secondNotificationView setAlpha:0];
 [firstNotificationView setAlpha:0];
 [imgNoReminder setAlpha:0];
 
 if([childArr count] == 0)
 {
 [self callAPI];
 }
 }
 
 imgCounter++;
 }
 */

@end
