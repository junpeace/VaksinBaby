//
//  editChildView.h
//  myVac4Baby
//
//  Created by jun on 11/5/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bizChild.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "JsonRequest.h"

#import "firstNotification.h"
#import "bizFirstNotification.h"
#import "SSKeychain.h"
#import "LocalizeHelper.h"
#import "latestNotification.h"

#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface editChildView : UIViewController<UIActionSheetDelegate, UITextFieldDelegate, NSURLConnectionDelegate>
{
    int imgCounter;
    int editLock;
    UIDatePicker *pickerView;
    CGFloat animatedDistance;
    int counter;
    NSString *strDOB, *strGender;
    NSMutableArray *notificationArr;
}

@property (strong, nonatomic) bizChild *child;
@property (weak, nonatomic) IBOutlet UITextField *txtChildName;
@property (weak, nonatomic) IBOutlet UIImageView *imgGirl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBoy;
- (IBAction)changeImg:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
- (IBAction)saveInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIImageView *imgBaby;

@end
