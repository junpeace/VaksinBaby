//
//  entryPointView.m
//  myVac4Baby
//
//  Created by jun on 11/7/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "entryPointView.h"

@interface entryPointView ()

@end

@implementation entryPointView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
}

-(void) setUpView
{
    int x = 0; // login status
    
    NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
    
    if (password != nil)
    {
        // Logged in
        x = 200;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"receivedReminder"])
        {
            x = 300;
        }
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // new user
        x = 100;
    }
    
    
    if(x == 0)
    {
        // user didnt login
        loginView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self.navigationController pushViewController:mmvc animated:NO];
        // [self.navigationController pushViewController:mmvc animated:YES];
    }
    else if(x == 100)
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];

        // This is the first launch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // registrationVC
        registrationView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"registrationVC"];
        [self.navigationController pushViewController:mmvc animated:NO];
    }
    else if(x == 200)
    {
        mainMenuView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
        [self.navigationController pushViewController:mmvc animated:NO];
        // [self.navigationController pushViewController:mmvc animated:YES];
    }
    else if(x == 300)
    {
        bizChild *child = [[bizChild alloc] init];
        [child setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        notificationViewLeftMenu *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"notificationVCLeftMenu"];
        mmvc.child_passBy = child;
        [self.navigationController pushViewController:mmvc animated:NO];
        // [self.navigationController pushViewController:mmvc animated:YES];
    }
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
