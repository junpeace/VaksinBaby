//
//  vaccinePreventableDiseaseView.h
//  myVac4Baby
//
//  Created by Jun on 14/10/28.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "NetworkHandler.h"
#import "SVProgressHUD.h"
#import "getAllVaccinePreventableDiseases.h"
#import "bizPreventableDiseases.h"
#import "vaccinePreventableDeseaseDetailsView.h"
#import "mainMenuView.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface vaccinePreventableDiseaseView : UIViewController
{
    int selectedVideoIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tblVaccinePreventableDisease;
- (IBAction)home:(id)sender;

@end
