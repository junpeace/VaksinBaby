//
//  notificationView.h
//  myVac4Baby
//
//  Created by jun on 1/27/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "firstNotification.h"
#import "secondNotification.h"
#import "bizReminderSecondNotificationMonth.h"
#import "bizReminderFirstNotificationNip.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "getChilds.h"
#import "SSKeychain.h"
#import "bizChild.h"
#import "UIImageView+WebCache.h"
#import "latestNotification.h"
#import "vaccinationDetailReminderView.h"
#import "nipDetailView.h"

@interface notificationView : UIViewController
{
    int selectedMonthIndex;
    int selectedNipIndex;
    int fromAdditonalVaccine;
    int fromAdditonalVaccine_selectedIndex;
    bizLatestNotification *notificationObj;
}

@property (strong, nonatomic) bizChild *child_passBy;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerTblChildHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblSecondNotificationHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationSecondHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondNotificationTableWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblNipHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNotificationViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *imgNoReminder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNotificationViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblNA;

@property (weak, nonatomic) IBOutlet UIImageView *lblNIP;
@property (weak, nonatomic) IBOutlet UIImageView *lblAC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblTitle24MonthsFromTop;
@property (weak, nonatomic) IBOutlet UITableView *tblAdditionalVaccines;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblAdditionalVaccineHeightConstraint;

/* @property (weak, nonatomic) IBOutlet UIWebView *webView; */

@end
