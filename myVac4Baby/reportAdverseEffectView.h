//
//  reportAdverseEffectView.h
//  myVac4Baby
//
//  Created by Jun on 14/10/28.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "mainMenuView.h"
#import "vaccinationTypeView.h"
#import "SVProgressHUD.h"
#import "NetworkHandler.h"
#import "submitAdverseEffectReport.h"
#import "LocalizeHelper.h"
#import "UITextField+Extended.h"
#import "getMomNameTelEmail_reportAdverseEffect.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface reportAdverseEffectView : UIViewController<UITextViewDelegate, UITextFieldDelegate, vaccinationTypeViewDelegate>
{
    UIDatePicker *pickerView;
    CGFloat animatedDistance;
    int counter;
    NSString *vaccinationDate;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
- (IBAction)home:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblReportTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNo;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblChildName;
@property (weak, nonatomic) IBOutlet UILabel *lblChildAge;
@property (weak, nonatomic) IBOutlet UILabel *lblVaccinationDate;
@property (weak, nonatomic) IBOutlet UILabel *lblVaccinationGiven;
@property (weak, nonatomic) IBOutlet UILabel *lblHistory;
@property (weak, nonatomic) IBOutlet UILabel *lblTreator;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (weak, nonatomic) IBOutlet UITextField *txtChildName;
@property (weak, nonatomic) IBOutlet UITextField *txtChildAge;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtVaccinationDate;
@property (weak, nonatomic) IBOutlet UITextField *txtVaccinationType;
@property (weak, nonatomic) IBOutlet UITextField *txtHospital;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtDoctorName;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
 
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
- (IBAction)getVaccinationType:(id)sender;
@property (strong, nonatomic) UIToolbar *keyboardToolbar;

@end
