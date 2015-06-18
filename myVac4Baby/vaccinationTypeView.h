//
//  vaccinationTypeView.h
//  myVac4Baby
//
//  Created by Jun on 14/11/7.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizeHelper.h"
#import "NetworkHandler.h"
#import "getAllVaccines.h"

@protocol vaccinationTypeViewDelegate <NSObject>
- (void)userHasCompletedSettings:(NSString *)vaccineType;
@end

@interface vaccinationTypeView : UIViewController<NetworkHandlerDelegate>
{
    int selectedIndex;
    NSIndexPath *pathSelected;
}

@property id<vaccinationTypeViewDelegate>myDelegate;

@property (strong, nonatomic) NSString *vaccinationType;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tblVaccinationType;

@end
