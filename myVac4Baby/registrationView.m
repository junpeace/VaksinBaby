//
//  registrationView.m
//  myVac4Baby
//
//  Created by jun on 11/7/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "registrationView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface registrationView ()

@end

@implementation registrationView
@synthesize revealLeftMenu;
@synthesize txtName, txtDate, txtEmail, txtMobile, txtPostcode, txtEmployer, txtHealthcarePreference, txtUsername, txtPassword, txtConfirmPassword, txtGender;
@synthesize lblDate, lblGender, lblName, lblEmail, lblPostcode, lblMobile, lblEmployer, lblHealthcarePreference, lblUsername, lblPassword, lblConfirmPassword;
@synthesize imgCheck;
@synthesize lbltnc, btnSubmit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD dismiss];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
     imgCounter = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    self.title = LocalizedString(@"Register");
    
    [lblName setText:LocalizedString(@"Name")];
    [lblGender setText:LocalizedString(@"Gender")];
    [lblDate setText:LocalizedString(@"D.O.B")];
    [lblEmail setText:LocalizedString(@"Email")];
    [lblMobile setText:LocalizedString(@"Mobile")];
    [lblPostcode setText:LocalizedString(@"Postcode")];
    [lblEmployer setText:LocalizedString(@"Employer")];
    [lblHealthcarePreference setText:LocalizedString(@"Healthcare Preference")];
    [lblUsername setText:LocalizedString(@"Username")];
    [lblPassword setText:LocalizedString(@"Password")];
    [lblConfirmPassword setText:LocalizedString(@"Confirm Password")];
    [lbltnc setText:LocalizedString(@"Agree to Terms & Conditions")];
    
    [txtName setPlaceholder:LocalizedString(@"As per I/C")];
    [txtGender setPlaceholder:LocalizedString(@"Options")];
    [txtDate setPlaceholder:LocalizedString(@"dd / mm / yyyy")];
    [txtEmail setPlaceholder:LocalizedString(@"name@email.com")];
    [txtMobile setPlaceholder:LocalizedString(@"+6 000 000 0000")];
    [txtPostcode setPlaceholder:LocalizedString(@"00000")];
    [txtUsername setPlaceholder:LocalizedString(@"20 characters")];
    [txtEmployer setPlaceholder:LocalizedString(@"Options")];
    [txtHealthcarePreference setPlaceholder:LocalizedString(@"Options")];
    [txtPassword setPlaceholder:LocalizedString(@"6 - 15 characters")];
    [txtConfirmPassword setPlaceholder:LocalizedString(@"Retype Password")];
    
    [btnSubmit setTitle:LocalizedString(@"Submit") forState:UIControlStateNormal];
    
    txtName.delegate = self;
    txtEmail.delegate = self;
    txtMobile.delegate = self;
    txtPostcode.delegate = self;
    txtUsername.delegate = self;
    txtPassword.delegate = self;
    
    txtEmail.nextTextField = txtMobile;
    txtMobile.nextTextField = txtPostcode;
    txtUsername.nextTextField = txtPassword;
    txtPassword.nextTextField = txtConfirmPassword;
    
    // numberic input only
    txtPostcode.keyboardType = UIKeyboardTypeDecimalPad;
    txtMobile.keyboardType = UIKeyboardTypeDecimalPad;
    
    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 320, 216)];
    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_SG"];
    
    [pickerView addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    [txtDate setInputView:pickerView];
    
    [txtPassword setSecureTextEntry:YES];
    [txtConfirmPassword setSecureTextEntry:YES];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.widthConstraint.constant = screenWidth;
    
    txtConfirmPassword.delegate = self;
    
    [self keyboardToolbarSetup];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    UITextField *next = theTextField.nextTextField;
    
    if (next) {
        [next becomeFirstResponder];
    } else {
        [theTextField resignFirstResponder];
        [self dismissKeyboard];
    }
    
    return NO;
}

-(void)updateTextField:(id)sender
{
    // show date
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd LLLL yyyy"];
    
    NSLocale* formatterLocale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter2 setLocale:formatterLocale2];
    
    NSString *showDate = [dateFormatter2 stringFromDate:[pickerView date]];
    
    [txtDate setText:showDate];
    
    // get selected date in the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSString *currentDate = [dateFormatter stringFromDate:[pickerView date]];
    
    dateOfBirth = [currentDate substringToIndex:10];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    [self setUpView];
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"registration";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"registration_receiveNotification"
                                               object:nil];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"registration_receiveNotification"])
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

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(void)dismissKeyboard {
    
    [txtName resignFirstResponder];
    [txtDate resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtPostcode resignFirstResponder];
    [txtEmployer resignFirstResponder];
    [txtHealthcarePreference resignFirstResponder];
    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
    [txtGender resignFirstResponder];
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

/*
- (IBAction)login:(id)sender {
    
    // loginVC
    
    loginView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}
 */

#pragma mark UITextField

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtName || textField == txtEmail || textField == txtMobile || textField == txtPostcode || textField == txtUsername)
    { return; }
    
    [self moveScreenUp:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == txtName || textField == txtEmail || textField == txtMobile || textField == txtPostcode || textField == txtUsername)
    { return; }
    
    [self moveScreenDown];
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
        
        NSLog(@"moveScreenUp %f", animatedDistance);

        if(animatedDistance < 150)
        {
            // ipod touch
            //animatedDistance = animatedDistance / 3;
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
    NSLog(@"move screen down");
    
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (IBAction)selectGender:(id)sender {
    
    [self performSegueWithIdentifier:@"genderSelectionSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"genderSelectionSegue"])
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
    else if([[segue identifier]isEqualToString:@"healthCareSegue"])
    {
        selectHealthcarePreferenceView *SegueController = (selectHealthcarePreferenceView*)[segue destinationViewController];
        SegueController.hp = txtHealthcarePreference.text;
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

-(void)userHasSelectedGender:(NSString *)gender
{
    // set selected gender here
    
    txtGender.text = gender;
}

-(void)userHasSelectedEmployer:(NSString *)employer
{
    // set selected gender here
    
    txtEmployer.text = employer;
}

-(void) userHasSelectedHP:(NSString *)hp
{
    txtHealthcarePreference.text = hp;
}

- (IBAction)selectEmployer:(id)sender {

    [self performSegueWithIdentifier:@"selectEmployerSegue" sender:nil];
}

- (IBAction)selectHealthCarePreference:(id)sender {
    
    [self performSegueWithIdentifier:@"healthCareSegue" sender:nil];
}

- (IBAction)submitRegistration:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self dismissKeyboard];
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    if([txtName.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your name") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtGender.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select your gender") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtGender.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Gender should not be more than 20 characters") :@"Important"];
        
        return;
    }
    
    if([txtDate.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select your Date of Birth") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtDate.text length] > 30)
    {
        [self showMessage:LocalizedString(@"D.O.B should not be more than 30 characters") :@"Important"];
        
        return;
    }
    
    if([txtEmail.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your email") :@"Incomplete Registration"];
        
        return;
    }
    else
    {
        if(![self NSStringIsValidEmail:txtEmail.text])
        {
            [self showMessage:LocalizedString(@"Please enter a valid email address") :@"Invalid Email"];
            
            return;
        }
    }
    
    if([txtEmail.text length] > 50)
    {
        [self showMessage:LocalizedString(@"Email should not be more than 50 characters") :@"Important"];
        
        return;
    }
    
    if([txtMobile.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your mobile number") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtMobile.text length] > 11)
    {
        [self showMessage:LocalizedString(@"Mobile no. should not be more than 11 characters") :@"Important"];
        
        return;
    }
    
    if([txtPostcode.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your postcode") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtPostcode.text length] > 5)
    {
        [self showMessage:LocalizedString(@"Postcode should not be more than 5 characters") :@"Invalid Postcode"];
        
        return;
    }
    
    if([txtEmployer.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select your employer type") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtEmployer.text length] > 30)
    {
        [self showMessage:LocalizedString(@"Employer should not be more than 30 characters") :@"Important"];
        
        return;
    }
    
    if([txtHealthcarePreference.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select your healthcare preference") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtHealthcarePreference.text length] > 50)
    {
        [self showMessage:LocalizedString(@"Healthcare preference should not be more than 50 characters") :@"Important"];
        
        return;
    }
    
    if([txtUsername.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your username") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtUsername.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Username should not be more than 20 characters") :@"Invalid Username"];
        
        return;
    }
    
    if([txtPassword.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your password") :@"Incomplete Registration"];
        
        return;
    }
    
    if([txtPassword.text length] < 6)
    {
        [self showMessage:LocalizedString(@"Password must be at least 6 characters") :@"Invalid Password"];
        
        return;
    }
    
    if([txtPassword.text length] > 15)
    {
        [self showMessage:LocalizedString(@"Password should not be more than 15 characters") :@"Invalid Password"];
        
        return;
    }
    
    if(![txtPassword.text isEqualToString:txtConfirmPassword.text])
    {
        [self showMessage:LocalizedString(@"Oops! Passwords entered do not match") :@"Error"];
        
        return;
    }
    
    // determine if user check on terms n conditions
    
    if(imgCounter % 2 == 0)
    {
        [self showMessage:LocalizedString(@"You have to accept the terms and conditions to use the application") :@"Important"];
        
        return;
    }
    
    // submit
    
    [self callAPI];
}

-(void) callAPI
{
    bizRegistration *registration = [[bizRegistration alloc] init];
    [registration setName:txtName.text];
    [registration setEmail:txtEmail.text];
    [registration setMobile:txtMobile.text];
    [registration setPassword:txtPassword.text];
    [registration setUsername:txtUsername.text];
    [registration setPostcode:txtPostcode.text];
    [registration setDob:dateOfBirth];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [registration setEmployer:txtEmployer.text];
        [registration setGender:txtGender.text];
        [registration setHp:txtHealthcarePreference.text];
    }
    else
    {
        [registration setEmployer:[self getEmployerInEnglish:txtEmployer.text]];
        [registration setGender:[self getGenderInEnglish:txtGender.text]];
        [registration setHp:[self getHpInEnglish:txtHealthcarePreference.text]];
    }
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    submitRegistration *request = [[submitRegistration alloc] init_submitRegistration:registration];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
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

- (IBAction)changeImg:(id)sender {
    
    imgCounter++;
    
    [self changeTickboxImg];
}

-(void) changeTickboxImg
{
    if(imgCounter % 2 == 0)
    {
        [imgCheck setImage:[UIImage imageNamed:@"btn_check"]];
    }
    else
    {
        [imgCheck setImage:[UIImage imageNamed:@"btn_check_active"]];
    }
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
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"registration"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Thank You")
                                                                  message:LocalizedString(@"Your profile has been created.") delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
                
                // set password session
                NSArray *temp = [responseMessage objectForKey:@"data"];
                
                for(int i = 0; i <temp.count; i++)
                {
                    NSString *pd = [NSString stringWithFormat:@"%@", [[temp objectAtIndex:i] objectForKey:@"momId"]];
                    
                    // set login session
                    [SSKeychain setPassword:pd forService:@"myVac4Baby" account:@"anyUser"];
                }
                
                // set username
                [[NSUserDefaults standardUserDefaults] setObject:txtUsername.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // navigate to main
                
                mainMenuView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
                [self.navigationController pushViewController:mmvc animated:YES];
            }
            else
            {
                NSString *str = [responseMessage objectForKey:@"message"];
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                                  message:LocalizedString(str) delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
                
            }
        }
    }
    
    counter = 0;
    
    [SVProgressHUD dismiss];
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

// http://stackoverflow.com/questions/158574/programmatically-align-a-toolbar-on-top-of-the-iphone-keyboard
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
    else if(txtEmail.isFirstResponder){ [txtEmail resignFirstResponder]; }
    else if(txtMobile.isFirstResponder){ [txtMobile resignFirstResponder]; [txtEmail becomeFirstResponder]; }
    else if(txtPostcode.isFirstResponder){ [txtPostcode resignFirstResponder]; [txtMobile becomeFirstResponder]; }
    else if(txtUsername.isFirstResponder){ [txtUsername resignFirstResponder]; }
    else if(txtPassword.isFirstResponder){ [txtPassword resignFirstResponder]; [txtUsername becomeFirstResponder]; }
    else if(txtConfirmPassword.isFirstResponder){ [txtConfirmPassword resignFirstResponder]; [txtPassword becomeFirstResponder]; }
}

-(void) moveToNextTextfield
{
    if(txtName.isFirstResponder){ [txtName resignFirstResponder]; }
    else if(txtEmail.isFirstResponder){ [txtEmail resignFirstResponder]; [txtMobile becomeFirstResponder]; }
    else if (txtMobile.isFirstResponder){ [txtMobile resignFirstResponder]; [txtPostcode becomeFirstResponder]; }
    else if(txtPostcode.isFirstResponder){ [txtPostcode resignFirstResponder]; }
    else if(txtUsername.isFirstResponder){ [txtUsername resignFirstResponder]; [txtPassword becomeFirstResponder]; }
    else if(txtPassword.isFirstResponder){ [txtPassword resignFirstResponder]; [txtConfirmPassword becomeFirstResponder]; }
    else if (txtConfirmPassword.isFirstResponder){ [txtConfirmPassword resignFirstResponder]; }
}

-(void) doneAction
{
    /* remove the keyboard from view */
    
    [self dismissKeyboard];
}

@end
