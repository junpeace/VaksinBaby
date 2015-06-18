//
//  mainMenuView.h
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "reminderView.h"
#import "videoView.h"
#import "otherResourcesView.h"
#import "vaccinationTrackerView.h"
#import "vaccinePreventableDiseaseView.h"
#import "reportAdverseEffectView.h"
#import "loginView.h"
#import "reminderView.h"
#import "LocalizeHelper.h"
#import "latestNotification.h"

@interface mainMenuView : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgReminder;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideo;
@property (weak, nonatomic) IBOutlet UIImageView *imgVaccinationTracker;
@property (weak, nonatomic) IBOutlet UIImageView *imgVaccinePreventableDiseases;
@property (weak, nonatomic) IBOutlet UIImageView *imgReportAdverseEffect;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *imgOtherResources;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnReminderPositionX_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnVaccinationPositionX_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnVideoPositionX_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnVaccinePreventableDiseasePositionX_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnOtherResourcesPositionX_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnReportAdverseEffectPositionX_Constraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnReminderPositionY_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnVaccinationTrackerPositionY_Constraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnOtherResourcesPositionY_Constraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnReportAdverseEffectPositionY_Constraint;

- (IBAction)loginView:(id)sender;

@end
