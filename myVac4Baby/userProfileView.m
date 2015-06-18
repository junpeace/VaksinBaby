//
//  userProfileView.m
//  myVac4Baby
//
//  Created by Jun on 14/11/2.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "userProfileView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface userProfileView ()

@end

@implementation userProfileView

@synthesize revealLeftMenu;
@synthesize imgChildProfile, imgMyProfile;
@synthesize tblChild;
@synthesize dataArr;
@synthesize scrollView;
@synthesize txtName, txtGender, txtDob, txtEmail, txtMobile, txtPostcode, txtEmployer, txtHp, txtUsername, txtPassword, txtConfirmPassword;
@synthesize lblGender, lblName, lblDob, lblEmail, lblMobile, lblPostcode, lblEmployer, lblHp, lblUsername, lblPassword, lblConfirmPassword;
@synthesize imgTick, btnSave, btnDisabledSave, btnEdit;
@synthesize childScrollView, lbltnc;
@synthesize lblNoChild;
@synthesize navigateFromSideMenuEditChild;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    profileSelected = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
    
    /* check if navigate from side menu (edit child) */
    
    if([navigateFromSideMenuEditChild isEqualToString:@"didNavigateFromSideMenu"])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgChildProfile setImage:[UIImage imageNamed:@"tab_childprofile_active"]];
            [imgMyProfile setImage:[UIImage imageNamed:@"tab_myprofile"]];
        }
        else
        {
            [imgChildProfile setImage:[UIImage imageNamed:@"bm_tab_childprofile_active"]];
            [imgMyProfile setImage:[UIImage imageNamed:@"bm_tab_myprofile"]];
        }
        
        [self getChildsProfile];
        
        profileSelected++; // increase index
    }
    else
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgChildProfile setImage:[UIImage imageNamed:@"bm_tab_childprofile"]];
            [imgMyProfile setImage:[UIImage imageNamed:@"bm_tab_myprofile_active"]];
        }
        
        /* only will call this method on first run */
        [self performSelector:@selector(getMomProfile) withObject:nil afterDelay:1];
    }
    
    [self keyboardToolbarSetup];
    
    imgCounter = 0;
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"userProfile_receiveNotification"])
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

-(void) getMomProfile
{
    // set disabled as default
    [self setFieldsAsDisabled];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getMomProfile *request = [[getMomProfile alloc] init_getMomProfile:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void)dismissKeyboard {
    
    [scrollView endEditing:YES];
    
    if(counter % 2 != 0)
    {
        [self moveScreenDown];
    }
    
    counter = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    [self setUpView];
    
    if(profileSelected % 2 != 0)
    { [self getChildsProfile]; }
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"userProfile";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"userProfile_receiveNotification"
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
    {
        [btnDisabledSave setImage:[UIImage imageNamed:@"bm_btn_save_disable"] forState:UIControlStateNormal];
        [btnSave setImage:[UIImage imageNamed:@"bm_btn_save"] forState:UIControlStateNormal];
        
        LocalizationSetLanguage(@"ms");
    }
    
    self.navigationItem.title = LocalizedString(@"User Profile");
    
    [lblName setText:LocalizedString(@"Name")];
    [lblMobile setText:LocalizedString(@"Mobile")];
    [lblEmail setText:LocalizedString(@"Email")];
    [lblGender setText:LocalizedString(@"Gender")];
    [lblDob setText:LocalizedString(@"D.O.B")];
    [lblPostcode setText:LocalizedString(@"Postcode")];
    [lblEmployer setText:LocalizedString(@"Employer")];
    [lblHp setText:LocalizedString(@"Healthcare Preference")];
    [lblUsername setText:LocalizedString(@"Username")];
    [lblPassword setText:LocalizedString(@"Password")];
    [lblConfirmPassword setText:LocalizedString(@"Confirm Password")];
    
    [btnEdit setTitle:LocalizedString(@"Edit") forState:UIControlStateNormal];
    [lbltnc setText:LocalizedString(@"I agree to the Terms & Conditions")];
    
    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 320, 216)];
    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_SG"];
    
    [pickerView addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    [txtDob setInputView:pickerView];
    
    [txtPassword setSecureTextEntry:YES];
    [txtConfirmPassword setSecureTextEntry:YES];
    
    txtPassword.delegate = self;
    txtPassword.tag = 100;
    txtConfirmPassword.delegate = self;
    txtConfirmPassword.tag = 200;
    
    txtName.delegate = self;
    txtEmail.delegate = self;
    txtMobile.delegate = self;
    txtPostcode.delegate = self;
    txtUsername.delegate = self;
    
    txtEmail.nextTextField = txtMobile;
    txtMobile.nextTextField = txtPostcode;
    txtUsername.nextTextField = txtPassword;
    txtPassword.nextTextField = txtConfirmPassword;
    
    // numberic input only
    txtPostcode.keyboardType = UIKeyboardTypeDecimalPad;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.widthConstraint.constant = screenWidth;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    UITextField *next = theTextField.nextTextField;
    
    if (next)
    {
        [next becomeFirstResponder];
    }
    else
    {
         [theTextField resignFirstResponder];
         [self dismissKeyboard];
    }
    
    return NO;
}

-(void) setFieldsAsDisabled
{
    [txtName setEnabled:NO];
    [txtDob setEnabled:NO];
    [txtEmail setEnabled:NO];
    [txtMobile setEnabled:NO];
    [txtPostcode setEnabled:NO];
    [txtUsername setEnabled:NO];
    [txtPassword setEnabled:NO];
    [txtConfirmPassword setEnabled:NO];
}

-(void) setFieldsEnabled
{
    [txtName setEnabled:YES];
    [txtDob setEnabled:YES];
    [txtEmail setEnabled:YES];
    [txtMobile setEnabled:YES];
    [txtPostcode setEnabled:YES];
    [txtUsername setEnabled:YES];
    [txtPassword setEnabled:YES];
    [txtConfirmPassword setEnabled:YES];
}

-(void)updateTextField:(id)sender
{
    // show date
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd LLLL yyyy"];
    
    NSLocale* formatterLocale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter2 setLocale:formatterLocale2];
    
    NSString *showDate = [dateFormatter2 stringFromDate:[pickerView date]];
    
    [txtDob setText:showDate];
    
    // get selected date in the correct format
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSString *currentDate = [dateFormatter stringFromDate:[pickerView date]];
    
    strDOB = [currentDate substringToIndex:10];
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

- (IBAction)switchImg:(id)sender {
    
    if(profileSelected % 2 == 0)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgChildProfile setImage:[UIImage imageNamed:@"tab_childprofile_active"]];
            [imgMyProfile setImage:[UIImage imageNamed:@"tab_myprofile"]];
        }
        else
        {
            [imgChildProfile setImage:[UIImage imageNamed:@"bm_tab_childprofile_active"]];
            [imgMyProfile setImage:[UIImage imageNamed:@"bm_tab_myprofile"]];
        }
        
        [self getChildsProfile];
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgChildProfile setImage:[UIImage imageNamed:@"tab_childprofile"]];
            [imgMyProfile setImage:[UIImage imageNamed:@"tab_myprofile_active"]];
        }
        else
        {
            [imgChildProfile setImage:[UIImage imageNamed:@"bm_tab_childprofile"]];
            [imgMyProfile setImage:[UIImage imageNamed:@"bm_tab_myprofile_active"]];
        }
        
        if([navigateFromSideMenuEditChild isEqualToString:@"didNavigateFromSideMenu"])
        {
            [self getMomProfile];
            navigateFromSideMenuEditChild = @""; // reset, only need to call once
        }
        
        [self getMyProfile];
    }
    
    profileSelected++;
}

-(void) getMyProfile
{
    [lblNoChild setAlpha:0];
    [tblChild setAlpha:0];
    [scrollView setAlpha:1];
    [childScrollView setAlpha:0];
}

-(void) getChildsProfile
{
    [self dismissKeyboard];
    
    [scrollView setAlpha:0];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self performSelector:@selector(callAPI) withObject:nil afterDelay:1];
}

-(void) callAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getChilds *request = [[getChilds alloc] init_getChilds:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getChildByMomId"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                dataArr = [[NSMutableArray alloc] init];
                
                NSArray *tempArr = [responseMessage objectForKey:@"data"];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    bizChild *child = [[bizChild alloc] init];
                    [child setChildId:[[tempArr objectAtIndex:i] objectForKey:@"child_id"]];
                    [child setChildName:[[tempArr objectAtIndex:i] objectForKey:@"child_name"]];
                    [child setChildGender:[[tempArr objectAtIndex:i] objectForKey:@"child_gender"]];
                    [child setChildDateOfBirth:[[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"]];
                    [child setChildImageUrl:[[tempArr objectAtIndex:i] objectForKey:@"child_image"]];
                    
                    [dataArr addObject:child];
                }
                
                // re-set child arr
                NSMutableArray *localArr = [[NSMutableArray alloc] init];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"type", [[tempArr objectAtIndex:i] objectForKey:@"child_name"], @"name", [[tempArr objectAtIndex:i] objectForKey:@"child_image"], @"url", [[tempArr objectAtIndex:i] objectForKey:@"child_id"], @"childId", [[tempArr objectAtIndex:i] objectForKey:@"child_gender"], @"gender", [[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"], @"dob",nil];
                    
                    [localArr addObject:dict];
                }
                
                [lblNoChild setAlpha:0];
                
                // set child object
                [[NSUserDefaults standardUserDefaults] setObject:localArr forKey:@"childArr"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                NSLog(@"getChildByMomId : error : - %@", responseMessage);
                
                // set different language display text
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                { LocalizationSetLanguage(@"en"); }
                else
                { LocalizationSetLanguage(@"ms"); }
                
                [lblNoChild setText:LocalizedString(@"No baby at the moment")];
                [lblNoChild setAlpha:1];
            }
            
            [self updateTableHeight:dataArr.count];
            
            [tblChild reloadData];
            [tblChild setAlpha:1];
            [childScrollView setAlpha:1];
            
            [SVProgressHUD dismiss];
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getMomProfile"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                NSArray *tempArr = [responseMessage objectForKey:@"data"];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    [txtName setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_name"]];

                    [txtDob setText:[self formatDate:[[tempArr objectAtIndex:i] objectForKey:@"mom_dob"]]];
                    [txtEmail setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_email"]];
                    [txtMobile setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_mobile"]];
                    [txtPostcode setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_postcode"]];
                    [txtUsername setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_username"]];
                    
                    //[txtPassword setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_password"]];
                    //[txtConfirmPassword setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_password"]];
                    [txtPassword setText:@"****"];
                    [txtConfirmPassword setText:@"****"];
                    
                    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                    {
                        [txtGender setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_gender"]];
                        [txtEmployer setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_employer"]];
                        [txtHp setText:[[tempArr objectAtIndex:i] objectForKey:@"mom_hp"]];
                    }
                    else
                    {
                        [txtGender setText:[self getGenderInMelayu:[[tempArr objectAtIndex:i] objectForKey:@"mom_gender"]]];
                        [txtEmployer setText:[self getEmployerInMelayu:[[tempArr objectAtIndex:i] objectForKey:@"mom_employer"]]];
                        [txtHp setText:[self getHpInMelayu:[[tempArr objectAtIndex:i] objectForKey:@"mom_hp"]]];
                    }
                    
                    strDOB = [[tempArr objectAtIndex:i] objectForKey:@"mom_dob"];
                }
            }
            else
            {
                NSLog(@"getMomProfile : no record found");
            }
            
            [SVProgressHUD dismiss];
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"editMomProfile"])
        {
            // set different language display text
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            { LocalizationSetLanguage(@"en"); }
            else
            { LocalizationSetLanguage(@"ms"); }
            
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                // set username
                [[NSUserDefaults standardUserDefaults] setObject:txtUsername.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Update Successful")
                        message:LocalizedString(@"Your user profile has been successfully updated") delegate:nil
                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
            }
            else
            {
                NSLog(@"editMomProfile : fail %@", responseMessage);
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                        message:LocalizedString(@"Oops! It looks like something went wrong. Please try to update your user profile again.") delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
                
            }
            
            [SVProgressHUD dismiss];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"childCell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    bizChild *child = [dataArr objectAtIndex:indexPath.row];
    
    UIImageView *imgBg = (UIImageView*)[cell viewWithTag:1];
    
    if( [child.childGender caseInsensitiveCompare:@"male"] == NSOrderedSame )
    {
        [imgBg setImage:[UIImage imageNamed:@"vaccinationtracker_boy"]];
    }
    else
    {
        [imgBg setImage:[UIImage imageNamed:@"vaccinationtracker_girl"]];
    }

    UIImageView *imgBaby = (UIImageView*)[cell viewWithTag:2];
    
    [imgBaby setImageWithURL:[NSURL URLWithString:child.childImageUrl] placeholderImage:[UIImage imageNamed:@"default_addaphotoofyourbaby"]];
    imgBaby.layer.cornerRadius = imgBaby.frame.size.height / 2;
    imgBaby.layer.masksToBounds = YES;
    imgBaby.layer.borderWidth = 1.0f;
    imgBaby.layer.borderColor = [UIColor whiteColor].CGColor;
    imgBaby.clipsToBounds = YES;
    imgBaby.contentMode = UIViewContentModeScaleAspectFit;

    UILabel *lblName_ = (UILabel*)[cell viewWithTag:3];
    [lblName_ setText:child.childName];
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index path : %d", indexPath.row);
    
    selectedChildIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"childDetailSegue" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.0f;
}

-(void) updateTableHeight :(int) count
{
    self.tblChildHeightConstraint.constant = 180;
    self.childViewHeightConstraint.constant = 489;
    
    // add 90.0f for extra 1
    
    int extra = count - 2;
    
    if(extra > 0)
    {
        int additon = extra * 90;
        
        self.tblChildHeightConstraint.constant += additon;
        
        int extra2 = count - 5;
        
        if(extra2 > 0)
        {
            if(extra2 == 1)
            {
                self.childViewHeightConstraint.constant += 30;
            }
            else
            {
                additon = extra2 * 90;
                
                self.childViewHeightConstraint.constant += additon;
            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"childDetailSegue"])
    {
        editChildView *SegueController = (editChildView*)[segue destinationViewController];
        SegueController.child = [dataArr objectAtIndex:selectedChildIndex];
    }
    else if([[segue identifier]isEqualToString:@"selectGenderSegue"])
    {
        genderSelectionView *SegueController = (genderSelectionView*)[segue destinationViewController];
        SegueController.gender = txtGender.text;
        SegueController.myDelegate = (id)self;
    }
    else if([[segue identifier]isEqualToString:@"selectEmployerSegue"])
    {
        selectEmployerView *SegueController = (selectEmployerView*)[segue destinationViewController];
        SegueController.employer = txtEmployer.text;
        SegueController.myDelegate = (id)self;
    }
    else if([[segue identifier]isEqualToString:@"selectHpSegue"])
    {
        selectHealthcarePreferenceView *SegueController = (selectHealthcarePreferenceView*)[segue destinationViewController];
        SegueController.hp = txtHp.text;
        SegueController.myDelegate = (id)self;
    }
    else if([[segue identifier]isEqualToString:@"gotoNotificationSegue"])
    {
        bizChild *child = [[bizChild alloc] init];
        [child setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        notificationView *SegueController = (notificationView*)[segue destinationViewController];
        SegueController.child_passBy = child;
    }
}

- (IBAction)selectGender:(id)sender {
    
    if(beginEdit == 0){ return; }
    
    [self performSegueWithIdentifier:@"selectGenderSegue" sender:nil];
}

-(void)userHasSelectedGender:(NSString *)gender
{
    // set selected gender here
    
    txtGender.text = gender;
}

- (IBAction)selectEmployer:(id)sender {
    
    if(beginEdit == 0){ return; }
    
    [self performSegueWithIdentifier:@"selectEmployerSegue" sender:nil];
}

-(void)userHasSelectedEmployer:(NSString *)employer
{
    // set selected gender here
    
    txtEmployer.text = employer;
}

- (IBAction)selectHp:(id)sender {
    
    if(beginEdit == 0){ return; }
    
    [self performSegueWithIdentifier:@"selectHpSegue" sender:nil];
}

-(void) userHasSelectedHP:(NSString *)hp
{
    txtHp.text = hp;
}

- (IBAction)changeImg:(id)sender {
    
    if(beginEdit == 0){ return; }
    
    imgCounter++;
    
    [self changeTickboxImg];
}

-(void) changeTickboxImg
{
    if(imgCounter % 2 == 0)
    {
        [imgTick setImage:[UIImage imageNamed:@"btn_check"]];
        [btnDisabledSave setAlpha:1];
    }
    else
    {
        [imgTick setImage:[UIImage imageNamed:@"btn_check_active"]];
        [btnDisabledSave setAlpha:0];
    }
}

/* animated distance is not global */

-(void) moveScreenUp: (UITextField *)textField
{
    counter = 1;
    
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

#pragma mark UITextField

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtName || textField == txtEmail || textField == txtMobile || textField == txtPostcode || textField == txtUsername)
    { return; }
    
    if(counter == 1)
    { return; }
    
    [self moveScreenUp:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // reset confirm password field
    if (textField.tag == 100)
    {
        if([txtConfirmPassword.text length] != 0)
        {
            txtConfirmPassword.text = @"";
        }
    }
    
    return YES;
}

- (IBAction)updateProfile:(id)sender {
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self dismissKeyboard];
    
    if([txtName.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your name")];
        
        return;
    }
    
    if([txtGender.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select your gender")];
        
        return;
    }
    
    if([txtGender.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Gender should not be more than 20 characters")];
        
        return;
    }
    
    if([txtDob.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select your D.O.B")];
        
        return;
    }
    
    if([txtDob.text length] > 30)
    {
        [self showMessage:LocalizedString(@"D.O.B should not be more than 30 characters")];
        
        return;
    }
    
    if([txtEmail.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your email")];
        
        return;
    }
    else
    {
        if(![self NSStringIsValidEmail:txtEmail.text])
        {
            [self showMessage:LocalizedString(@"Please fill in a valid email address")];
            
            return;
        }
    }
    
    if([txtEmail.text length] > 50)
    {
        [self showMessage:LocalizedString(@"Email should not be more than 50 characters")];
        
        return;
    }
    
    if([txtMobile.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your mobile no")];
        
        return;
    }
    
    if([txtMobile.text length] > 11)
    {
        [self showMessage:LocalizedString(@"Mobile no. should not be more than 11 characters")];
        
        return;
    }
    
    if([txtPostcode.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your postcode")];
        
        return;
    }
    
    if([txtPostcode.text length] > 5)
    {
        [self showMessage:LocalizedString(@"Postcode should not be more than 5 characters")];
        
        return;
    }
    
    if([txtEmployer.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select your employer")];
        
        return;
    }
    
    if([txtEmployer.text length] > 30)
    {
        [self showMessage:LocalizedString(@"Employer should not be more than 30 characters")];
        
        return;
    }
    
    if([txtHp.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select your healthcare preference")];
        
        return;
    }
    
    if([txtHp.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Healthcare preference should not be more than 20 characters")];
        
        return;
    }
    
    if([txtUsername.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your username")];
        
        return;
    }
    
    if([txtUsername.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Username should not be more than 20 characters")];
        
        return;
    }
    
    if([txtPassword.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your password")];
        
        return;
    }
    
    if([txtPassword.text length] < 6)
    {
        if([txtPassword.text isEqualToString:@"****"])
        {
            // ok...
        }
        else
        {
            [self showMessage:LocalizedString(@"Password must be at least 6 characters")];
            
            return;
        }
    }
    
    if([txtPassword.text length] > 15)
    {
        [self showMessage:LocalizedString(@"Password should not be more than 15 characters")];
        
        return;
    }
    
    if(![txtPassword.text isEqualToString:txtConfirmPassword.text])
    {
        [self showMessage:LocalizedString(@"Password is not the same with confirm password field")];
        
        return;
    }
    
    // determine if user check on terms n conditions
    
    if(imgCounter % 2 == 0)
    {
        [self showMessage:LocalizedString(@"Please tick the Terms & Conditions checkbox before submit")];
        
        return;
    }
    
    
    [self updateMomProfile];
}

-(void) showMessage :(NSString*)msg
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Important")
                                                      message:msg delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
    
    [SVProgressHUD dismiss];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) updateMomProfile
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    bizEditMomProfile *momProfile = [[bizEditMomProfile alloc] init];
    [momProfile setName:txtName.text];
    [momProfile setDob:strDOB];
    [momProfile setEmail:txtEmail.text];
    [momProfile setMobile:txtMobile.text];
    [momProfile setPostcode:txtPostcode.text];
    [momProfile setUsername:txtUsername.text];
    [momProfile setPassword:txtPassword.text];
    [momProfile setMomId:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"]];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [momProfile setGender:txtGender.text];
        [momProfile setEmployer:txtEmployer.text];
        [momProfile setHp:txtHp.text];
    }
    else
    {
        [momProfile setEmployer:[self getEmployerInEnglish:txtEmployer.text]];
        [momProfile setGender:[self getGenderInEnglish:txtGender.text]];
        [momProfile setHp:[self getHpInEnglish:txtHp.text]];
    }
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    updateMomProfile *request = [[updateMomProfile alloc] init_updateMomProfile:momProfile];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

- (IBAction)edit:(id)sender {
    
    beginEdit = 1;
    
    [btnEdit setAlpha:0];
    
    [self setFieldsEnabled];
}

-(NSString*) formatDate:(NSString*) childDateOfBirth
{
    NSArray *stringArray = [childDateOfBirth componentsSeparatedByString: @"-"];
    NSString *monthName = @"";
    
    if([stringArray count] == 3)
    {
        switch ([[stringArray objectAtIndex:1] intValue]) {
            case 1:
                monthName = @"January";
                break;
            case 2:
                monthName = @"February";
                break;
            case 3:
                monthName = @"March";
                break;
            case 4:
                monthName = @"April";
                break;
            case 5:
                monthName = @"May";
                break;
            case 6:
                monthName = @"June";
                break;
            case 7:
                monthName = @"July";
                break;
            case 8:
                monthName = @"August";
                break;
            case 9:
                monthName = @"September";
                break;
            case 10:
                monthName = @"October";
                break;
            case 11:
                monthName = @"November";
                break;
            case 12:
                monthName = @"December";
                break;
                
            default:
                break;
        }
        
        return [NSString stringWithFormat:@"%@ %@ %@", [stringArray objectAtIndex:2], monthName, [stringArray objectAtIndex:0]];
    }
    
    return @"";
}

-(NSString*) getHpInEnglish :(NSString*) hp
{
    NSString *str;
    
    if([hp isEqualToString:@"Kerajaan"])
    {
        str = @"Government";
    }
    else if([hp isEqualToString:@"Swasta"])
    {
        str = @"Private";
    }
    
    return str;
}

-(NSString*) getEmployerInEnglish :(NSString*)employer
{
    NSString *str;
    
    if([employer isEqualToString:@"Kerajaan"])
    {
        str = @"Government";
    }
    else if([employer isEqualToString:@"Swasta"])
    {
        str = @"Private";
    }
    else if([employer isEqualToString:@"Perniagaan Sendiri"])
    {
        str = @"Own Business";
    }
    else if([employer isEqualToString:@"Tidak Bekerja"])
    {
        str = @"Not employed";
    }
    
    return str;
}

-(NSString*) getGenderInEnglish :(NSString*)gender
{
    NSString *str;
    
    if([gender isEqualToString:@"Perempuan"])
    {
        str = @"Female";
    }
    else if([gender isEqualToString:@"Lelaki"])
    {
        str = @"Male";
    }
    
    return str;
}

-(NSString*) getGenderInMelayu :(NSString*)gender
{
    NSString *str;
    
    if([gender isEqualToString:@"Female"])
    {
        str = @"Perempuan";
    }
    else if([gender isEqualToString:@"Male"])
    {
        str = @"Lelaki";
    }
    
    return str;
}

-(NSString*) getEmployerInMelayu :(NSString*)employer
{
    NSString *str;
    
    if([employer isEqualToString:@"Government"])
    {
        str = @"Kerajaan";
    }
    else if([employer isEqualToString:@"Private"])
    {
        str = @"Swasta";
    }
    else if([employer isEqualToString:@"Own Business"])
    {
        str = @"Perniagaan Sendiri";
    }
    else if([employer isEqualToString:@"Not employed"])
    {
        str = @"Tidak Bekerja";
    }
    
    return str;
}

-(NSString*) getHpInMelayu :(NSString*) hp
{
    NSString *str;
    
    if([hp isEqualToString:@"Government"])
    {
        str = @"Kerajaan";
    }
    else if([hp isEqualToString:@"Private"])
    {
        str = @"Swasta";
    }
    
    return str;
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
        
        txtName.inputAccessoryView = self.keyboardToolbar;
        txtDob.inputAccessoryView = self.keyboardToolbar;
        txtEmail.inputAccessoryView = self.keyboardToolbar;
        txtMobile.inputAccessoryView = self.keyboardToolbar;
        txtPostcode.inputAccessoryView = self.keyboardToolbar;
        txtUsername.inputAccessoryView = self.keyboardToolbar;
        txtPassword.inputAccessoryView = self.keyboardToolbar;
        txtConfirmPassword.inputAccessoryView = self.keyboardToolbar;
    }
}

-(void) moveToPrevTextfield
{
    if(txtName.isFirstResponder){ [txtName resignFirstResponder]; }
    else if(txtDob.isFirstResponder){ [txtDob resignFirstResponder]; }
    else if(txtEmail.isFirstResponder){ [txtEmail resignFirstResponder]; [txtDob becomeFirstResponder]; }
    else if(txtMobile.isFirstResponder){ [txtMobile resignFirstResponder]; [txtEmail becomeFirstResponder]; }
    else if(txtPostcode.isFirstResponder){ [txtPostcode resignFirstResponder]; [txtMobile becomeFirstResponder]; }
    else if(txtUsername.isFirstResponder){ [txtUsername resignFirstResponder]; }
    else if(txtPassword.isFirstResponder){ [txtPassword resignFirstResponder]; [txtUsername becomeFirstResponder]; }
    else if(txtConfirmPassword.isFirstResponder){ [txtConfirmPassword resignFirstResponder]; [txtPassword becomeFirstResponder]; }
}

-(void) moveToNextTextfield
{
    if(txtName.isFirstResponder){ [txtName resignFirstResponder]; }
    else if(txtDob.isFirstResponder){ [txtDob resignFirstResponder]; [txtEmail becomeFirstResponder]; }
    else if(txtEmail.isFirstResponder){ [txtEmail resignFirstResponder]; [txtMobile becomeFirstResponder]; }
    else if(txtMobile.isFirstResponder){ [txtMobile resignFirstResponder]; [txtPostcode becomeFirstResponder]; }
    else if(txtPostcode.isFirstResponder){ [txtPostcode resignFirstResponder]; }
    else if(txtUsername.isFirstResponder){ [txtUsername resignFirstResponder]; [txtPassword becomeFirstResponder]; }
    else if(txtPassword.isFirstResponder)
    {
        if(counter != 1)
        { [self moveScreenUp:txtPassword]; }
        
        [txtPassword resignFirstResponder]; [txtConfirmPassword becomeFirstResponder];
    }
    else if(txtConfirmPassword.isFirstResponder){ [txtConfirmPassword resignFirstResponder]; }
}

-(void) doneAction
{
    /* remove the keyboard from view */
    
    [self dismissKeyboard];
}

@end
