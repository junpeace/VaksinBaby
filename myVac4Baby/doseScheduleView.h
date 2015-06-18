//
//  doseScheduleView.h
//  myVac4Baby
//
//  Created by jun on 11/11/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bizChild.h"
#import "bizVaccine.h"
#import "SVProgressHUD.h"
#import "getChildVaccineCard.h"
#import "NetworkHandler.h"
#import "bizChildVaccineCard.h"
#import "updateVaccineCard.h"
#import "LocalizeHelper.h"

@interface doseScheduleView : UIViewController<NetworkHandlerDelegate>
{
    int imgCounter;
    int showDefault;
}

@property (strong, nonatomic) bizChild *child;
@property (strong, nonatomic) bizVaccine *vaccine;

- (IBAction)changeImg:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgSchedule;
@property (weak, nonatomic) IBOutlet UIImageView *imgDose;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblBgHeigtConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgNameBg;
@property (weak, nonatomic) IBOutlet UITableView *tblSchedule;
@property (strong, nonatomic) NSMutableArray *scheduleArr;
@property (strong, nonatomic) NSMutableArray *doseArr;
@property (weak, nonatomic) IBOutlet UITableView *tblDose;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
- (IBAction)update:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)submit:(id)sender;
@property (strong, nonatomic) NSMutableArray *doseTakenArr;

@end
