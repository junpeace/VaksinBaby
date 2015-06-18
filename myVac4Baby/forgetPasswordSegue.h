//
//  forgetPasswordSegue.h
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"
#import "forgetPassword.h"
#import "SVProgressHUD.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface forgetPasswordSegue : UIViewController
- (IBAction)sendPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

@end
