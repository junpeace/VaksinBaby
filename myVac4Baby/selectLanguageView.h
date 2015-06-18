//
//  selectLanguageView.h
//  myVac4Baby
//
//  Created by Jun on 14/10/28.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "mainMenuView.h"
#import "LocalizeHelper.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface selectLanguageView : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
- (IBAction)home:(id)sender;
@property (strong, nonatomic) NSString *fromLeftMenu;
- (IBAction)english:(id)sender;
- (IBAction)bahasaMalaysia:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;

@end
