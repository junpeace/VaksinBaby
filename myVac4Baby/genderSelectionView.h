//
//  genderSelectionView.h
//  myVac4Baby
//
//  Created by Jun on 14/11/8.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizeHelper.h"

@protocol genderSelectionViewDelegate <NSObject>
- (void)userHasSelectedGender:(NSString *)gender;
@end

@interface genderSelectionView : UIViewController
{
    int selectedIndex;
    NSIndexPath *pathSelected;
}

@property id<genderSelectionViewDelegate>myDelegate;

@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tblGender;

@end
