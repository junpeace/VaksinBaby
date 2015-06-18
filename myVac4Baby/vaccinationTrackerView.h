//
//  vaccinationTrackerView.h
//  myVac4Baby
//
//  Created by jun on 10/31/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "NetworkHandler.h"
#import "bizChild.h"
#import "getChilds.h"
#import "SVProgressHUD.h"
#import "mainMenuView.h"
#import "UIImageView+WebCache.h"
#import "vaccinationTrackerDetailView.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface vaccinationTrackerView : UIViewController<NetworkHandlerDelegate>
{
    int selectedChildIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UILabel *lblTrackerText;
- (IBAction)home:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblVaccinationTracker;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vaccineViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblNoChild;

@end
