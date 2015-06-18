//
//  reportAdverseEffectView.m
//  myVac4Baby
//
//  Created by Jun on 14/10/28.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "reportAdverseEffectView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface reportAdverseEffectView ()

@end

@implementation reportAdverseEffectView

@synthesize revealLeftMenu;
@synthesize lblReportTitle;
@synthesize lblChildAge, lblChildName, lblDesc, lblEmail, lblHistory, lblMobileNo, lblName, lblTreator, lblVaccinationDate, lblVaccinationGiven;
@synthesize txtName, txtMobileNo, txtChildName, txtChildAge, txtEmail, txtVaccinationDate, txtVaccinationType, txtHospital, txtDoctorName, txtDescription;
@synthesize scrollView, btnSubmit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self getMomNameTelEmail];
    
    [self performSelector:@selector(setUpView) withObject:nil afterDelay:1];
    
    [self keyboardToolbarSetup];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"reportAdversedEffect_receiveNotification"])
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

-(void) getMomNameTelEmail
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getMomNameTelEmail_reportAdverseEffect *request = [[getMomNameTelEmail_reportAdverseEffect alloc] init_getMomNameTelEmail_reportAdverseEffect: [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void)dismissKeyboard {
        
    [txtName resignFirstResponder];
    [txtMobileNo resignFirstResponder];
    [txtChildName resignFirstResponder];
    [txtChildAge resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtVaccinationDate resignFirstResponder];
    [txtVaccinationType resignFirstResponder];
    [txtHospital resignFirstResponder];
    [txtDoctorName resignFirstResponder];
    [txtDescription resignFirstResponder];
    
    if(counter % 2 != 0)
    {
        [self moveScreenDown];
    }
    
    counter = 0;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"reportAdversedEffect";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"reportAdversedEffect_receiveNotification"
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
    
    self.navigationItem.title = LocalizedString(@"Report Adverse Effect");
    
    NSString *str = LocalizedString(@"Please report any unexpected reaction your child may have experienced after vaccination to the Ministry of Health of Malaysia using the form below.");
    
    // If uncertain, please key in "unsure"
    
    [lblReportTitle setText:str];
    [lblName setText:LocalizedString(@"Name")];
    [lblMobileNo setText:LocalizedString(@"Mobile")];
    [lblEmail setText:LocalizedString(@"Email")];
    [lblChildName setText:LocalizedString(@"Child's Name")];
    [lblChildAge setText:LocalizedString(@"Child's Age")];
    [lblVaccinationDate setText:LocalizedString(@"Vaccination Date")];
    [lblVaccinationGiven setText:LocalizedString(@"What vaccine did your child receive?")];
    [lblHistory setText:LocalizedString(@"Hospital or clinic where the vaccination was given")];
    [lblTreator setText:LocalizedString(@"Name of doctor or nurse")];
    [lblDesc setText:LocalizedString(@"Description of the adverse effect at injection site:")];
    
    [txtName setPlaceholder:LocalizedString(@"Name")];
    [txtMobileNo setPlaceholder:LocalizedString(@"Mobile")];
    [txtEmail setPlaceholder:LocalizedString(@"Email")];
    [txtVaccinationDate setPlaceholder:LocalizedString(@"dd/mm/yy")];
    [txtChildName setPlaceholder:LocalizedString(@"As per Mykid")];
    [txtChildAge setPlaceholder:LocalizedString(@"Type your child's age here")];
    [txtVaccinationType setPlaceholder:LocalizedString(@"Select a vaccination type")];
    [txtHospital setPlaceholder:LocalizedString(@"Type hospital/clinic here")];
    [txtDoctorName setPlaceholder:LocalizedString(@"Type doctor/nurse's name here")];
    [txtDescription setText:LocalizedString(@"Type your description")];
    
    [btnSubmit setTitle:LocalizedString(@"Submit") forState:UIControlStateNormal];
    
    txtName.delegate = self;
    txtMobileNo.delegate = self;
    txtEmail.delegate = self;
    txtChildName.delegate = self;
    txtChildAge.delegate = self;
    txtHospital.delegate = self;
    txtDescription.delegate = self;
    txtDoctorName.delegate = self;
    
    txtName.nextTextField = txtMobileNo;
    txtMobileNo.nextTextField = txtEmail;
    txtEmail.nextTextField = txtChildName;
    txtChildName.nextTextField = txtChildAge;
    txtChildAge.nextTextField = txtVaccinationDate;
    txtHospital.nextTextField = txtDoctorName;
    txtDoctorName.nextTextField = (UITextField*) txtDescription;
    
    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 320, 216)];
    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_SG"];
    
    [pickerView addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    [txtVaccinationDate setInputView:pickerView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.widthConstraint.constant = screenWidth;
    
    [scrollView setAlpha:1];
    
    [SVProgressHUD dismiss];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    UITextField *next = theTextField.nextTextField;
    
    if(next == txtChildAge)
    {
        [self moveScreenUp:next];
    }
    
    if (next) {
        
        [next becomeFirstResponder];
    } else {
        [theTextField resignFirstResponder];
    }
    
    return NO;
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

-(void)updateTextField:(id)sender
{
    // show date
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd LLLL yyyy"];
    
    NSLocale* formatterLocale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter2 setLocale:formatterLocale2];
    
    NSString *showDate = [dateFormatter2 stringFromDate:[pickerView date]];
    
    [txtVaccinationDate setText:showDate];
    
    
    // get selected date in the correct format
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSString *currentDate = [dateFormatter stringFromDate:[pickerView date]];
    
    vaccinationDate = [currentDate substringToIndex:10];
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

- (IBAction)submit:(id)sender {
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    // validation - what field is necessary - ALL
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    if([txtName.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your name") :@"Important"];
        
        return;
    }
    
    if([txtName.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Name should not be more than 20 characters") :@"Important"];
        
        return;
    }
    
    if([txtMobileNo.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your mobile no") :@"Important"];
        
        return;
    }
    
    if([txtMobileNo.text length] > 11)
    {
        [self showMessage:LocalizedString(@"Mobile no. should not be more than 11 characters") :@"Important"];
        
        return;
    }
    
    if([txtEmail.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in your email") :@"Important"];
        
        return;
    }
    else
    {
        if(![self NSStringIsValidEmail:txtEmail.text])
        {
            [self showMessage:LocalizedString(@"Please fill in a valid email address") :@"Important"];
            
            return;
        }
    }
    
    if([txtEmail.text length] > 50)
    {
        [self showMessage:LocalizedString(@"Email should not be more than 50 characters") :@"Important"];
        
        return;
    }
    
    if([txtChildName.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please enter your child's name") :@"Incomplete Details"];
        
        return;
    }
    
    if([txtChildName.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Oops! Your child's name cannot be more than 20 characters") :@"Error"];
        
        return;
    }
    
    if([txtChildAge.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please enter your child's age") :@"Incomplete Details"];
        
        return;
    }
    
    if([txtChildAge.text length] > 100)
    {
        [self showMessage:LocalizedString(@"Child age should not be more than 100 characters") :@"Important"];
        
        return;
    }
    
    if([txtVaccinationDate.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please select the date when your child was vaccinated") :@"Incomplete Details"];
        
        return;
    }
    
    if([txtVaccinationDate.text length] > 30)
    {
        [self showMessage:@"Vaccination date should not be more than 30 characters" :@"Important"];
        
        return;
    }
    
    if([txtVaccinationType.text length] == 0)
    {
        [self showMessage:@"Please select type of vaccination" :@"Incomplete Details"];
        
        return;
    }
    
    if([txtVaccinationType.text length] > 100)
    {
        [self showMessage:LocalizedString(@"Vaccination type should not be more than 100 characters") :@"Important"];
        
        return;
    }
    
    if([txtHospital.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in hospital/clinic name") :@"Incomplete Details"];
        
        return;
    }
    
    if([txtHospital.text length] > 100)
    {
        [self showMessage:LocalizedString(@"Oops! The name of the Hospital cannot be more than 100 characters") :@"Error"];
        
        return;
    }
    
    if([txtDoctorName.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in doctor/nurse name") :@"Incomplete Details"];
        
        return;
    }
    
    if([txtDoctorName.text length] > 20)
    {
        [self showMessage:LocalizedString(@"Oops! The name of your Doctor/nurse name cannot be more than 20 characters") :@"Error"];
        
        return;
    }
    
    if([txtDescription.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in description of the adverse effect") :@"Important"];
        
        return;
    }
    
    [self callAPI];
}

-(void) callAPI
{
    bizAdverseReport *report = [[bizAdverseReport alloc] init];
    [report setName:txtName.text];
    [report setMobileNo:txtMobileNo.text];
    [report setEmail:txtEmail.text];
    [report setChildName:txtChildName.text];
    [report setChildAge:txtChildAge.text];
    [report setVaccineDate:vaccinationDate];
    [report setTypeOfVaccine:txtVaccinationType.text];
    [report setHospital:txtHospital.text];
    [report setDoctName:txtDoctorName.text];
    [report setIllDesc:txtDescription.text];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    submitAdverseEffectReport *request = [[submitAdverseEffectReport alloc] init_submitAdverseEffectReport:report];
    
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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    txtDescription.text = @"";
    
    [self moveScreenUp:(UITextField*)textView];
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    if(txtDescription.text.length == 0)
    {
        txtDescription.text = LocalizedString(@"Type your description");
        
        [txtDescription resignFirstResponder];
    }
}

-(void) moveScreenUp: (UITextField *)textField
{
    // do not move screen up when the screen is already up
    if(counter == 1){ return; }
    
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

- (IBAction)getVaccinationType:(id)sender {
    
    [self performSegueWithIdentifier:@"vaccinationTypeSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"vaccinationTypeSegue"])
    {
        vaccinationTypeView *SegueController = (vaccinationTypeView*)[segue destinationViewController];
        SegueController.vaccinationType = txtVaccinationType.text;
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

-(void)userHasCompletedSettings:(NSString *)userSettings
{
    // set selected vaccination type here
    
    txtVaccinationType.text = userSettings;
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
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"reportAdversedEffect"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Report Sent")
                            message:LocalizedString(@"Your report has been delivered successfully. The Ministry of Health Malaysia will be in contact should they require any further details.") delegate:nil
                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 
                 [message show];
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                            message:LocalizedString(@"Oops! We're sorry Mommy. It looks like your report could not be sent. Please check your internet connection and try again.") delegate:nil
                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
            }
            
            [SVProgressHUD dismiss];
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getMomNameTelEmail_reportAdverseEffect"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                NSArray *data = [responseMessage objectForKey:@"data"];
                
                if(data.count != 0)
                {
                    txtName.text = [NSString stringWithFormat:@"%@", [[data objectAtIndex:0] objectForKey:@"mom_name"]];
                    txtMobileNo.text = [NSString stringWithFormat:@"%@", [[data objectAtIndex:0] objectForKey:@"mom_mobile"]];
                    txtEmail.text = [NSString stringWithFormat:@"%@", [[data objectAtIndex:0] objectForKey:@"mom_email"]];
                }
            }
            else
            {
                // fail to fetch mom's details
                
                NSLog(@"fail to fetch mom details");
            }
        }
    }
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
        txtMobileNo.inputAccessoryView = self.keyboardToolbar;
        txtEmail.inputAccessoryView = self.keyboardToolbar;
        txtChildName.inputAccessoryView = self.keyboardToolbar;
        txtChildAge.inputAccessoryView = self.keyboardToolbar;
        txtVaccinationDate.inputAccessoryView = self.keyboardToolbar;
        txtHospital.inputAccessoryView = self.keyboardToolbar;
        txtDoctorName.inputAccessoryView = self.keyboardToolbar;
    }
}

-(void) moveToPrevTextfield
{
    if(txtName.isFirstResponder){ [txtName resignFirstResponder]; }
    else if(txtMobileNo.isFirstResponder){ [txtMobileNo resignFirstResponder]; [txtName becomeFirstResponder]; }
    else if(txtEmail.isFirstResponder){ [txtEmail resignFirstResponder]; [txtMobileNo becomeFirstResponder]; }
    else if(txtChildName.isFirstResponder){ [txtChildName resignFirstResponder]; [txtEmail becomeFirstResponder]; }
    else if(txtChildAge.isFirstResponder){ [txtChildAge resignFirstResponder]; [txtChildName becomeFirstResponder]; }
    else if(txtVaccinationDate.isFirstResponder){ [txtVaccinationDate resignFirstResponder]; [txtChildAge becomeFirstResponder]; }
    else if(txtHospital.isFirstResponder){ [txtHospital resignFirstResponder]; }
    else if(txtDoctorName.isFirstResponder){ [txtDoctorName resignFirstResponder]; [txtHospital becomeFirstResponder]; }
}

-(void) moveToNextTextfield
{
    if(txtName.isFirstResponder){ [txtName resignFirstResponder]; [txtMobileNo becomeFirstResponder]; }
    else if(txtMobileNo.isFirstResponder){ [txtMobileNo resignFirstResponder]; [txtEmail becomeFirstResponder]; }
    else if(txtEmail.isFirstResponder){ [txtEmail resignFirstResponder]; [txtChildName becomeFirstResponder]; }
    else if(txtChildName.isFirstResponder){ [txtChildName resignFirstResponder]; [txtChildAge becomeFirstResponder]; }
    else if(txtChildAge.isFirstResponder){ [txtChildAge resignFirstResponder]; [txtVaccinationDate becomeFirstResponder]; }
    else if(txtVaccinationDate.isFirstResponder){ [txtVaccinationDate resignFirstResponder]; }
    else if(txtHospital.isFirstResponder){ [txtHospital resignFirstResponder]; [txtDoctorName becomeFirstResponder]; }
    else if(txtDoctorName.isFirstResponder){ [txtDoctorName resignFirstResponder]; }
}

-(void) doneAction
{
    /* remove the keyboard from view */
    
    [self dismissKeyboard];
}

@end
