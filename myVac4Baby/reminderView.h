//
//  reminderView.h
//  myVac4Baby
//
//  Created by jun on 10/31/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "mainMenuView.h"
#import "NetworkHandler.h"
#import "firstNotification.h"
#import "secondNotification.h"
#import "bizReminderSecondNotificationMonth.h"
#import "bizReminderFirstNotificationNip.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

// #import "nipDetailView.h"
// #import "vaccinationDetailReminderView.h"

@interface reminderView : UIViewController<NetworkHandlerDelegate>
{
    int imgCounter;
    int selectedMonthIndex;
    int selectedChildIndex;
    int selectedNipIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UIView *reminderView_;
@property (weak, nonatomic) IBOutlet UILabel *lblRegisterText;
@property (weak, nonatomic) IBOutlet UIButton *btnAddChild;
- (IBAction)home:(id)sender;
- (IBAction)createChild:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tblChild;
@property (strong, nonatomic) NSMutableArray *childArr;
@property (weak, nonatomic) IBOutlet UIView *registerView;

@property (strong, nonatomic) NSMutableArray *monthArr;
@property (weak, nonatomic) IBOutlet UITableView *tbl2ndNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblBubbleTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBubbleDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imgSecondNotificationChild;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirstNotificationChild;
@property (weak, nonatomic) IBOutlet UITableView *tblNIP;

@property (strong, nonatomic) NSMutableArray *nipArr;

@property (weak, nonatomic) IBOutlet UILabel *lblBubbleTitle1st;
@property (weak, nonatomic) IBOutlet UILabel *lblBubbleDetail1st;

@property (weak, nonatomic) IBOutlet UIScrollView *registerScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *secondNotificationView;
@property (weak, nonatomic) IBOutlet UIScrollView *firstNotificationView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerContentWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationSecondContentWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerContentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerTblChildHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnAddChildFromBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblSecondNotificationHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationSecondHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblNA;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondNotificationTableWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblNipHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNotificationViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIImageView *imgNoReminder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNotificationViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *lblNIP;
@property (weak, nonatomic) IBOutlet UIImageView *lblAC;

/* - (IBAction)changeImg:(id)sender; */
/* @property (weak, nonatomic) IBOutlet UIImageView *imgRegister; */
/* @property (weak, nonatomic) IBOutlet UIImageView *imgReminder; */
/* @property (weak, nonatomic) IBOutlet UIImageView *imgBaby_Reminder; */

@end
