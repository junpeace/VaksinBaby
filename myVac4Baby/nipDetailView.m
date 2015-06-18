//
//  nipDetailView.m
//  myVac4Baby
//
//  Created by Jun on 14/11/17.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "nipDetailView.h"

@interface nipDetailView ()

@end

@implementation nipDetailView

@synthesize webView;
@synthesize nip;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    self.navigationItem.title = [self getViewTitle : nip.nipTitle];
    
        
    [self setUpView];
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    self.navigationController.navigationBar.topItem.title = @"";

    if([nip.nipUrl isEqualToString:@""])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Url empty")
                                    message:LocalizedString(@"Please make sure an url is presented") delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        [SVProgressHUD dismiss];
        
        return;
    }
    
    NSString *fullURL = [NSString stringWithFormat:@"%@", nip.nipUrl];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    // [webView setScalesPageToFit:YES];
    [webView loadRequest:requestObj];
    
    webView.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start");
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
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Important")
                                                      message:LocalizedString(@"Please check your internet connection") delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
    
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) getViewTitle :(NSString*) nipTitle
{
    NSLog(@"nip title : %@", nipTitle);
    
    NSString *title = @"";
    
    if([nipTitle isEqualToString:@"BCG - Single Dose"])
    {
        title = @"BCG for Tuberculosis";
    }
    else if ([nipTitle isEqualToString:@"Hep B - Dose 1"])
    {
        title = @"Hepatitis B";
    }
    else if([nipTitle isEqualToString:@"Hep B - Dose 2"] || [nipTitle isEqualToString:@"Hep B - Dose 3"])
    {
        title = @"Hepatitis B";
    }
    else if([nipTitle isEqualToString:@"DTP - Dose 1"] || [nipTitle isEqualToString:@"DTP - Dose 2"] || [nipTitle isEqualToString:@"DTP - Dose 3"] || [nipTitle isEqualToString:@"DTP - Booster Dose"])
    {
        title = @"Diphtheria, Tetanus, Pertussis (DTP)";
    }
    else if([nipTitle isEqualToString:@"Polio Dose 1"] || [nipTitle isEqualToString:@"Polio - Dose 2"] || [nipTitle isEqualToString:@"Polio - Dose 3"] || [nipTitle isEqualToString:@"POLIO - Booster Dose"])
    {
        title = @"Poliomyelitis (Polio)";
    }
    else if([nipTitle isEqualToString:@"Hib - Dose 1"] || [nipTitle isEqualToString:@"Hib - Dose 2"] || [nipTitle isEqualToString:@"Hib - Dose 3"] || [nipTitle isEqualToString:@"Hib - Booster Dose"])
    {
        title = @"Haemophilus influenzae type b";
    }
    else if([nipTitle isEqualToString:@"Measley - Dose 1(Sabah only)"] || [nipTitle isEqualToString:@"7 years - 2nd Dose - Measles & Rubella"])
    {
        title = @"Measles";
    }
    else if([nipTitle isEqualToString:@"JE - Dose 1(Sarawak only)"] || [nipTitle isEqualToString:@"2nd Dose - JE (Sarawak only)"])
    {
        title = @"Japanese Encephalitis (JE)";
    }
    else if([nipTitle isEqualToString:@"MMR - Dose 1"])
    {
        title = @"Measles, Mumps, Rubella (MMR)";
    }
    else if([nipTitle isEqualToString:@"Rotavirus"])
    {
        title = @"Rotavirus";
    }
    else if([nipTitle isEqualToString:@"Pneumococcal Vaccine"])
    {
        title = @"Pneumococcal Vaccine";
    }
    else if([nipTitle isEqualToString:@"Meningococcal Vaccine"])
    {
        title = @"Meningococcal Vaccine";
    }
    else if([nipTitle isEqualToString:@"Influenza"])
    {
        title = @"Influenza";
    }
    else if([nipTitle isEqualToString:@"Hep A"])
    {
        title = @"Hep A";
    }
    else if([nipTitle isEqualToString:@"Chickenpox (Varicella)"])
    {
        title = @"Chickenpox (Varicella)";
    }
    else if([nipTitle isEqualToString:@"7 years - Booster Dose - DT"])
    {
        title = @"Diphtheria & Tetanus (DT)";
    }
    else if([nipTitle isEqualToString:@"13 years - 2 doses - HPV"])
    {
        title = @"HPV";
    }
    else if([nipTitle isEqualToString:@"15 years - Booster Dose - Tetanus"])
    {
        title = @"Tetanus";
    }
    
    return title;
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
