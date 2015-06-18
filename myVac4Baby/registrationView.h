//
//  registrationView.h
//  myVac4Baby
//
//  Created by jun on 11/7/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "loginView.h"
#import "genderSelectionView.h"
#import "selectEmployerView.h"
#import "selectHealthcarePreferenceView.h"
#import "NetworkHandler.h"
#import "SVProgressHUD.h"
#import "submitRegistration.h"
#import "mainMenuView.h"
#import "LocalizeHelper.h"
#import "UITextField+Extended.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface registrationView : UIViewController<UITextFieldDelegate, genderSelectionViewDelegate, selectEmployerViewDelegate, selectHealthcarePreferenceViewDelegate, NetworkHandlerDelegate>
{
    UIDatePicker *pickerView;
    CGFloat animatedDistance;
    int counter;
    int imgCounter;
    NSString *dateOfBirth;
}

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPostcode;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployer;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtPostcode;
@property (weak, nonatomic) IBOutlet UITextField *txtEmployer;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
- (IBAction)selectGender:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet UITextField *txtHealthcarePreference;
@property (weak, nonatomic) IBOutlet UILabel *lblHealthcarePreference;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
- (IBAction)selectEmployer:(id)sender;
- (IBAction)selectHealthCarePreference:(id)sender;

- (IBAction)submitRegistration:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;

- (IBAction)changeImg:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbltnc;
@property (strong, nonatomic) UIToolbar *keyboardToolbar;

// - (IBAction)login:(id)sender;


@end
