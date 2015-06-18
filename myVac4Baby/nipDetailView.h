//
//  nipDetailView.h
//  myVac4Baby
//
//  Created by Jun on 14/11/17.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "bizReminderFirstNotificationNip.h"
#import "LocalizeHelper.h"

@interface nipDetailView : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) bizReminderFirstNotificationNip *nip;

@end
