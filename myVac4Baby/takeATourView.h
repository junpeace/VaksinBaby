//
//  takeATourView.h
//  myVac4Baby
//
//  Created by Jun on 14/10/28.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "ICETutorialController.h"
#import "mainMenuView.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface takeATourView : UIViewController<ICETutorialControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) ICETutorialController *viewController;
- (IBAction)home:(id)sender;

@end
