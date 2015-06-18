//
//  editChild_leftMenu.h
//  myVac4Baby
//
//  Created by Jun on 15/1/25.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "JsonRequest.h"

#import "firstNotification.h"
#import "bizFirstNotification.h"
#import "SSKeychain.h"
#import "LocalizeHelper.h"

#import "SWRevealViewController.h"
#import "latestNotification.h"
#import "userProfileView.h"

#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface editChild_leftMenu : UIViewController<UIActionSheetDelegate, UITextFieldDelegate, NSURLConnectionDelegate>
{
    int imgCounter;
    int editLock;
    UIDatePicker *pickerView;
    CGFloat animatedDistance;
    int counter;
    NSString *strDOB, *strGender;
    NSArray *childProfile;
    NSMutableArray *notificationArr;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;

@property (weak, nonatomic) IBOutlet UITextField *txtChildName;
@property (weak, nonatomic) IBOutlet UIImageView *imgGirl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBoy;
- (IBAction)changeImg:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
- (IBAction)saveInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIImageView *imgBaby;

@end
