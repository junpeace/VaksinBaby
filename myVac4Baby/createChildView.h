//
//  createChildView.h
//  myVac4Baby
//
//  Created by jun on 11/3/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "childDetailView.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"
#import "reminderView.h"
#import "LocalizeHelper.h"
#import "latestNotification.h"

@interface createChildView : UIViewController<UIActionSheetDelegate>
{
    int skipChildPhoto;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgBaby;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateChild;
- (IBAction)proceed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)skipAddChildPhoto:(id)sender;

@end
