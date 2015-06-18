//
//  otherResourcesView.h
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

@interface otherResourcesView : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
- (IBAction)visitWebsite:(id)sender;
- (IBAction)visitFacebook:(id)sender;
- (IBAction)signUpNewsLetter:(id)sender;
- (IBAction)home:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnVisitOurWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnLikeUsOnFB;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUpENewsLetter;

@end
