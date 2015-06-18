//
//  loginView.h
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "mainMenuView.h"
#import "registrationView.h"
#import "login.h"
#import "NetworkHandler.h"
#import "SSKeychain.h"
#import "LocalizeHelper.h"

@interface loginView : UIViewController<NetworkHandlerDelegate>
{
    CGFloat animatedDistance;
    NSMutableArray *notificationArr;
}

- (IBAction)skip:(id)sender;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
- (IBAction)registration:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthSizeConstraint;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnRegistration;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) UIToolbar *keyboardToolbar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollCustomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCustomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoConstantToBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblUsernameConstantFromLogo;


@end
