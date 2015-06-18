//
//  createChild_leftMenu.h
//  myVac4Baby
//
//  Created by Jun on 14/11/10.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "childDetail_leftMenu.h"
#import "SWRevealViewController.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface createChild_leftMenu : UIViewController<UIActionSheetDelegate>
{
    int skipChildPhoto;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgBaby;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateChild;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)skipAddChildPhoto:(id)sender;
- (IBAction)proceed:(id)sender;

@end
