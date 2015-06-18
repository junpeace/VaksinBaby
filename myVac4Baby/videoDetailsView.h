//
//  videoDetailsView.h
//  myVac4Baby
//
//  Created by jun on 10/30/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "bizVideo.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface videoDetailsView : UIViewController<UIWebViewDelegate>

- (IBAction)play:(id)sender;
@property (nonatomic,strong) MPMoviePlayerController* mc;
@property (strong, nonatomic) bizVideo *video;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSnapshot;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgMustWatch;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoDuration;
@property (weak, nonatomic) IBOutlet UIImageView *imgLength;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;



@end
