//
//  signUpNewsLetterSegue.m
//  myVac4Baby
//
//  Created by jun on 10/30/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "signUpNewsLetterSegue.h"

@interface signUpNewsLetterSegue ()

@end

@implementation signUpNewsLetterSegue

@synthesize lblTnc;
@synthesize txtEmail, txtMobileNo, txtName;
@synthesize imgTick, btnSubmit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) receiveNotification:(NSNotification *) notification
{    
    if ([[notification name] isEqualToString:@"signUpNewsLetterView_receiveNotification"])
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

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dismissKeyboard {
    [txtEmail resignFirstResponder];
    [txtName resignFirstResponder];
    [txtMobileNo resignFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"signUpNewsLetter";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"signUpNewsLetterView_receiveNotification"
                                               object:nil];
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    NSString *str = LocalizedString(@"Yes! I would like to receive regular updates and newsletters from Immunise4life");
    
    [lblTnc setText:str];
    
    self.navigationItem.title = LocalizedString(@"Sign Up For E-Newsletter");
    [txtName setPlaceholder:LocalizedString(@"Name")];
    [txtEmail setPlaceholder:LocalizedString(@"Email Address")];
    [txtMobileNo setPlaceholder:LocalizedString(@"Mobile No")];
    [btnSubmit setTitle:LocalizedString(@"Submit") forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    txtName.delegate = self;
    txtEmail.delegate = self;
    
    txtName.nextTextField = txtEmail;
    txtEmail.nextTextField = txtMobileNo;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert1:)];
    tap.numberOfTapsRequired = 1;
    [lblTnc setUserInteractionEnabled:YES];
    [lblTnc addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert1:)];
    tap2.numberOfTapsRequired = 1;
    [imgTick setUserInteractionEnabled:YES];
    [imgTick addGestureRecognizer:tap2];
    
    counter = 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    UITextField *next = theTextField.nextTextField;
    
    if (next) {
        [next becomeFirstResponder];
    } else {
        [theTextField resignFirstResponder];
    }
    
    return NO;
}

-(void) changeTickboxImg
{
    if(counter % 2 == 0)
    {
        [imgTick setImage:[UIImage imageNamed:@"btn_check"]];
    }
    else
    {
        [imgTick setImage:[UIImage imageNamed:@"btn_check_active"]];
    }
}

- (void)showAlert1:(UITapGestureRecognizer *)sender
{
    counter++;
    
    [self changeTickboxImg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signUp:(id)sender
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    if([txtName.text length] == 0)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Incomplete Details")
                message:LocalizedString(@"Please fill in required (*) fields.") delegate:nil
                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        /* set placeholder in color */
        
        NSString *str = LocalizedString(@"Name*");
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range = [str rangeOfString:@"*"];
        
        if (range.location != NSNotFound)
        {       [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, 1)];    }
        
        txtName.attributedPlaceholder = string;
        
        /* end of setting */
        
        if([txtEmail.text length] == 0)
        {
            /* set txtDob placeholder in color */
            
            str = LocalizedString(@"Email Address*");
            string = [[NSMutableAttributedString alloc] initWithString:str];
            range = [str rangeOfString:@"*"];
            
            if (range.location != NSNotFound)
            {       [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, 1)];    }
            
            txtEmail.attributedPlaceholder = string;
            
            /* end of setting */
        }
        
        return;
    }
    
    if([txtEmail.text length] == 0)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Incomplete Details")
                message:LocalizedString(@"Please fill in required (*) fields.") delegate:nil
                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        /* set placeholder in color */
        
        NSString *str = LocalizedString(@"Email Address*");
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range = [str rangeOfString:@"*"];
        
        if (range.location != NSNotFound)
        {       [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, 1)];    }
        
        txtEmail.attributedPlaceholder = string;
        
        /* end of setting */
        
        return;
    }
    
    if(![self NSStringIsValidEmail:txtEmail.text])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
             message:LocalizedString(@"Please enter a valid email address") delegate:nil
                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        return;
    }
    
    /*
    
     // mobile no no longer compulsory
     
    if([txtMobileNo.text length] == 0)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Incomplete Details")
                                                          message:LocalizedString(@"Please fill in your mobile number") delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        return;
    }
     
    */
    
    if(counter % 2 == 0)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Incomplete Details")
                    message:LocalizedString(@"Oops! You have to agree to the terms and conditions to use the application.") delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        return;
    }
    
    [self callAPI];
}

-(void) callAPI
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    signUpNewsLetter *request = [[signUpNewsLetter alloc] init_signUp:txtEmail.text iname:txtName.text imobileno:txtMobileNo.text];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"signUpNewsLetter"])
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Sign Up Successful")
                     message:LocalizedString(@"Congratulations, you have been signed up for our newsletter.") delegate:nil
                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [message show];
            
            [SVProgressHUD dismiss];
                        
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        NSLog(@"error :- signUpNewsLetter");
    }
}

@end
