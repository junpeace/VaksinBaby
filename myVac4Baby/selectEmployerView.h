//
//  selectEmployerView.h
//  myVac4Baby
//
//  Created by Jun on 14/11/8.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizeHelper.h"

@protocol selectEmployerViewDelegate <NSObject>
- (void)userHasSelectedEmployer:(NSString *)employer;
@end

@interface selectEmployerView : UIViewController
{
    int selectedIndex;
    NSIndexPath *pathSelected;
}

@property (strong, nonatomic) NSString *employer;
@property id<selectEmployerViewDelegate>myDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tblEmployer;

@property (strong, nonatomic) NSMutableArray *dataArr;

@end
