//
//  vaccinePreventableDeseaseDetailsView.m
//  myVac4Baby
//
//  Created by jun on 10/31/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "vaccinePreventableDeseaseDetailsView.h"

@interface vaccinePreventableDeseaseDetailsView ()

@end

@implementation vaccinePreventableDeseaseDetailsView

@synthesize vaccine;
@synthesize viewWeb;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"vaccinePreventableDiseaseWebView_receiveNotification"])
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

-(void) viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    // self.title = [NSString stringWithFormat:@"%@", vaccine.preventableDiseaseName];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@", vaccine.preventableDiseaseName];
    
    [self setUpView];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"vaccinePreventableDiseaseWebView";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"vaccinePreventableDiseaseWebView_receiveNotification"
                                               object:nil];
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }

    self.navigationController.navigationBar.topItem.title = @"";
    
    if([vaccine.preventableDiseaseUrl isEqualToString:@""])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Url empty")
              message:LocalizedString(@"Please make sure an url is presented") delegate:nil
                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        [SVProgressHUD dismiss];
        
        return;
    }
        
    NSString *fullURL = [NSString stringWithFormat:@"%@", vaccine.preventableDiseaseUrl];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];

    //[viewWeb setScalesPageToFit:YES];
    [viewWeb loadRequest:requestObj];
    
    viewWeb.delegate = self;

    /*
     NSURL *nsurl = [NSURL URLWithString:url];
     
     NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
     
     [tnc loadRequest:nsrequest];
     
     [self.view addSubview:tnc];
     */
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start - vaccinePreventableDeseaseDetailsView");
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
        
    UIView *v = viewWeb;
    
    while (v)
    {
        v.backgroundColor = [UIColor whiteColor];
        v = [v.subviews firstObject];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }

    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                      message:LocalizedString(@"Sorry Mommy, looks like we cannot communicate with the servers. Please check your internet connection and try again.") delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
    
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
