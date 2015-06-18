//
//  videoDetailsView.m
//  myVac4Baby
//
//  Created by jun on 10/30/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "videoDetailsView.h"

@interface videoDetailsView ()

@end

@implementation videoDetailsView

@synthesize video;
@synthesize imgSnapshot, lblVideoDescription, lblVideoDuration, lblVideoTitle;
@synthesize imgMustWatch;
@synthesize btnPlay, imgLength, line, bgView;
@synthesize webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"videoDetail_receiveNotification"])
    {
        /* check if user log in */
        
        NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
        
        if (password == nil)
        {
            // loginVC
            
            loginView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            [self.navigationController pushViewController:mmvc animated:YES];
            
            return;
        }
        
        /* redirect user to either read more or update */
        
        if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationType"] intValue] == 1)
        {
            [self performSegueWithIdentifier:@"gotoNotificationSegue" sender:nil];
        }
        else if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"pushNotificationType"] intValue] == 2)
        {
            NSLog(@"update ");
            
            [self performSegueWithIdentifier:@"gotoNotificationSegue" sender:nil];
        }
        else
        { /* invalid condition */ }
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"Videos";
    
    [self performSelector:@selector(setUpView) withObject:nil afterDelay:1];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"videoDetail";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"videoDetail_receiveNotification"
                                               object:nil];
}

-(void) setUpView
{
    lblVideoTitle.text = video.videoTitle;
    lblVideoDescription.text = video.videoDescription;
    lblVideoDuration.text = video.videoDuration;
        
    if([video.videoMustWatch isEqualToString:@"1"])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            imgMustWatch.image = [UIImage imageNamed:@"icon_mustwatch_active"];
        }
        else
        {
            imgMustWatch.image = [UIImage imageNamed:@"bm_icon_mustwatch_active"];
        }
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            // imgMustWatch.image = [UIImage imageNamed:@"icon_mustwatch"];
        }
        else
        {
            // imgMustWatch.image = [UIImage imageNamed:@"bm_icon_mustwatch"];
        }
        
        [imgMustWatch setAlpha:0];
    }
    
    [imgLength setImage:[UIImage imageNamed:@"icon_length"]];
    
    [line setImage:[UIImage imageNamed:@"line_1"]];
    
    [bgView setAlpha:1];
    
    [self initWebView];
}

-(void) initWebView
{
    // youtube sample, could be play inline
    // NSString *urlAddress = [NSString stringWithFormat:@"<body style=\"margin:0\"><iframe src='https://www.youtube.com/embed/RBumgq5yVrA?feature=player_detailpage&playsinline=1' width='320px' height='170px' frameborder='0'></iframe></body>"];

    // NSString *urlAddress = [NSString stringWithFormat:@"<body style=\"margin:0\"><iframe src='http://player.vimeo.com/video/%@' width='320px' height='170px' frameborder='0' webkit-playsinline='webkit-playsinline'></iframe></body>", video.vimeoId];
    
    /*NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1] ;
    [html appendString:@"<html><head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"body {"];
    [html appendString:@"background-color: transparent;"];
    [html appendString:@"color: white;"];
    [html appendString:@"}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head><body style=\"margin:0\">"];
    [html appendString:@"<video src=\"https://vimeo.com/channels/staffpicks/120960412\" width=\"320\" height=\"170\" webkit-playsinline />"];
    [html appendString:@"</body></html>"];
    
    
    webview.delegate = self;
    webview.scrollView.scrollEnabled = NO;
    webview.allowsInlineMediaPlayback = YES;
    [webview loadHTMLString:html baseURL:nil];*/
    
    
    
    
    
    // http://stackoverflow.com/questions/14258833/how-to-force-vimeo-player-to-play-inline-using-uiwebview
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    webview.frame = self.view.frame;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"failed to load video");
    
    [SVProgressHUD dismiss];
}

- (UIImage*)loadImage :(NSString*) urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(11, 65);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);
    
    UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
    
    return FrameImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"gotoNotificationSegue"])
    {
        bizChild *child = [[bizChild alloc] init];
        [child setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        notificationView *SegueController = (notificationView*)[segue destinationViewController];
        SegueController.child_passBy = child;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)play:(id)sender
{
    
}

@end
