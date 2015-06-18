//
//  tncView.m
//  myVac4Baby
//
//  Created by jun on 4/8/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "tncView.h"

@interface tncView ()

@end

@implementation tncView

@synthesize revealLeftMenu;
@synthesize viewWeb;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self setUpView];
    
    [self customSetup];
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

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.title = LocalizedString(@"Terms & Conditions");
    
    NSString *fullURL = @"http://54.251.175.250/MyVac4Baby/vaksin_html/tnc.html";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [viewWeb loadRequest:requestObj];
    
    viewWeb.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start - tnc");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
