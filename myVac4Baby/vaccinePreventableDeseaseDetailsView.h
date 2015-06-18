//
//  vaccinePreventableDeseaseDetailsView.h
//  myVac4Baby
//
//  Created by jun on 10/31/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bizPreventableDiseases.h"
#import "SVProgressHUD.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface vaccinePreventableDeseaseDetailsView : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) bizPreventableDiseases *vaccine;
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;

@end
