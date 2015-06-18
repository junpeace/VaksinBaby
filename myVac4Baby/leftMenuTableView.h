//
//  leftMenuTableView.h
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "selectLanguageView.h"
#import "LocalizeHelper.h"

@interface SWUITableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UILabel *label;
@end

@interface leftMenuTableView : UITableViewController
{
    int loginStatus;
    int numberOfChild;
    NSString *username;
    NSMutableArray *temp;
    NSArray *filteredArray;
}

@property (strong, nonatomic) NSMutableArray *dataArr;

@end
