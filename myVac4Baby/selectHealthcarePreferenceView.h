//
//  selectHealthcarePreferenceView.h
//  myVac4Baby
//
//  Created by Jun on 14/11/8.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizeHelper.h"

@protocol selectHealthcarePreferenceViewDelegate <NSObject>
- (void)userHasSelectedHP:(NSString *)hp;
@end

@interface selectHealthcarePreferenceView : UIViewController
{
    int selectedIndex;
    NSIndexPath *pathSelected;
}

@property (strong, nonatomic) NSString *hp;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property id<selectHealthcarePreferenceViewDelegate>myDelegate;

@property (weak, nonatomic) IBOutlet UITableView *tblHp;

@end
