//
//  childDetail_leftMenu.h
//  myVac4Baby
//
//  Created by Jun on 14/11/10.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonRequest.h"
#import "SVProgressHUD.h"

#import "firstNotification.h"
#import "bizFirstNotification.h"
#import "reminderView.h"
#import "LocalizeHelper.h"
#import "latestNotification.h"

#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface childDetail_leftMenu : UIViewController<UITextFieldDelegate, NSURLConnectionDelegate>
{
    UIDatePicker *pickerView;
    CGFloat animatedDistance;
    int counter;
    int imgCounter;
    NSString *strDOB;
    NSMutableArray *notificationArr;
}

@property (weak, nonatomic) IBOutlet UITextField *txtChildName;

@property (strong, nonatomic) UIImage *imgBaby;
@property (weak, nonatomic) IBOutlet UIImageView *imgChild;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (weak, nonatomic) IBOutlet UIImageView *imgGirl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBoy;

- (IBAction)changeImage:(id)sender;
- (IBAction)createChild:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) NSString *strSkipAddChild;
 
@end
