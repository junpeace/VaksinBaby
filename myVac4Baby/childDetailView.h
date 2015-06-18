//
//  childDetailView.h
//  myVac4Baby
//
//  Created by jun on 11/4/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonRequest.h"
#import "SVProgressHUD.h"

#import "firstNotification.h"
#import "bizFirstNotification.h"

#import "reminderView.h"
#import "LocalizeHelper.h"
#import "latestNotification.h"

@interface childDetailView : UIViewController<UITextFieldDelegate, NSURLConnectionDelegate>
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
@property (strong, nonatomic) NSString *strSkipAddChild;
@property (weak, nonatomic) IBOutlet UIImageView *imgChild;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (weak, nonatomic) IBOutlet UIImageView *imgGirl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBoy;

- (IBAction)changeImage:(id)sender;
- (IBAction)createChild:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end
