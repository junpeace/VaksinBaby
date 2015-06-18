//
//  signUpNewsLetterSegue.h
//  myVac4Baby
//
//  Created by jun on 10/30/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"
#import "SVProgressHUD.h"
#import "signUpNewsLetter.h"
#import "LocalizeHelper.h"
#import "UITextField+Extended.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface signUpNewsLetterSegue : UIViewController<NetworkHandlerDelegate, UITextFieldDelegate>
{
    int counter;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTnc;
- (IBAction)signUp:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (weak, nonatomic) IBOutlet UIImageView *imgTick;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end
