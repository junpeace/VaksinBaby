//
//  vaccinationTrackerDetailView.h
//  myVac4Baby
//
//  Created by jun on 11/5/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bizChild.h"
#import "bizVaccine.h"
#import "NetworkHandler.h"
#import "getAllVaccines.h"
#import "doseScheduleView.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface vaccinationTrackerDetailView : UIViewController<NetworkHandlerDelegate>
{
    int selectedVaccineIndex;
}

@property (strong, nonatomic) bizChild *child;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tblVaccinationTracker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgEssential;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdditional;

@end
