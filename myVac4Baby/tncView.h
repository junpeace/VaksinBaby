//
//  tncView.h
//  myVac4Baby
//
//  Created by jun on 4/8/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "LocalizeHelper.h"
#import "SVProgressHUD.h"

@interface tncView : UIViewController<UIWebViewDelegate>
{

}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;

@end
