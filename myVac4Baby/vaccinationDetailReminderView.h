//
//  vaccinationDetailReminderView.h
//  myVac4Baby
//
//  Created by jun on 11/14/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bizReminderSecondNotificationMonth.h"
#import "NetworkHandler.h"
#import "getVaccineByIds.h"
#import "bizVaccine.h"
#import "bizChild.h"
#import "doseScheduleView.h"
#import "getVaccinesForSecondReminder.h"
#import "updateVaccineCardSecondReminders.h"

@interface vaccinationDetailReminderView : UIViewController<NetworkHandlerDelegate>
{
    int selectedIndex;
}

@property (strong, nonatomic) bizChild *child;
@property (weak, nonatomic) IBOutlet UIImageView *imgMonth;
@property (strong, nonatomic) bizReminderSecondNotificationMonth *obj;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tblVaccine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpdate;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *monthWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblWidthConstraint;
@property (strong, nonatomic) NSMutableArray *doseTakenArr;
- (IBAction)submit:(id)sender;


@end
