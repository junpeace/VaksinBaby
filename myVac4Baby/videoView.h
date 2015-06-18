//
//  videoView.h
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "NetworkHandler.h"
#import "getAllVideos.h"
#import "bizVideo.h"
#import "videoDetailsView.h"
#import "mainMenuView.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface videoView : UIViewController<NetworkHandlerDelegate, UIWebViewDelegate>
{
    int selectedVideoIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tblVideo;
- (IBAction)home:(id)sender;

@end
