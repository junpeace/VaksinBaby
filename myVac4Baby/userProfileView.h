//
//  userProfileView.h
//  myVac4Baby
//
//  Created by Jun on 14/11/2.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "mainMenuView.h"
#import "NetworkHandler.h"
#import "bizChild.h"
#import "getChilds.h"
#import "SVProgressHUD.h"
#import "editChildView.h"
#import "genderSelectionView.h"
#import "selectEmployerView.h"
#import "selectHealthcarePreferenceView.h"
#import "getMomProfile.h"
#import "updateMomProfile.h"
#import "bizEditMomProfile.h"
#import "LocalizeHelper.h"
#import "UITextField+Extended.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface userProfileView : UIViewController<NetworkHandlerDelegate, genderSelectionViewDelegate, selectEmployerViewDelegate, selectHealthcarePreferenceViewDelegate, UITextFieldDelegate>
{
    int profileSelected; // change this to nsinteger
    int selectedChildIndex;
    UIDatePicker *pickerView;
    int counter;
    int imgCounter;
    CGFloat animatedDistance;
    int beginEdit;
    NSString *strDOB;
}

@property (weak, nonatomic) IBOutlet UILabel *lblConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (IBAction)changeImg:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
- (IBAction)home:(id)sender;
- (IBAction)switchImg:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgChildProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgMyProfile;
@property (weak, nonatomic) IBOutlet UITableView *tblChild;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDob;
- (IBAction)selectHp:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtDob;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UILabel *lblPostcode;
@property (weak, nonatomic) IBOutlet UILabel *lblNoChild;
@property (weak, nonatomic) IBOutlet UITextField *txtPostcode;
@property (weak, nonatomic) IBOutlet UITextField *txtEmployer;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployer;
@property (weak, nonatomic) IBOutlet UILabel *lblHp;
- (IBAction)selectEmployer:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtHp;
- (IBAction)selectGender:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgTick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)updateProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDisabledSave;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

- (IBAction)edit:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lbltnc;

@property (weak, nonatomic) IBOutlet UIScrollView *childScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblChildHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *childViewHeightConstraint;
@property (strong, nonatomic) UIToolbar *keyboardToolbar;
@property (strong, nonatomic) NSString *navigateFromSideMenuEditChild;

@end
