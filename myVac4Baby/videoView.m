//
//  videoView.m
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "videoView.h"

@interface videoView ()

@end

@implementation videoView

@synthesize revealLeftMenu;
@synthesize dataArr;
@synthesize tblVideo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self performSelector:@selector(callAPI) withObject:nil afterDelay:1];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"video_receiveNotification"])
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
    [self customSetup];
    
    self.navigationItem.title = @"Videos";
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"video";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"video_receiveNotification"
                                               object:nil];
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    // prevent front view from interacting
    if (position == FrontViewPositionRight) { // Menu is shown
        self.navigationController.interactivePopGestureRecognizer.enabled = NO; // Prevents the iOS7’s pan gesture
        self.view.userInteractionEnabled = NO;
    } else if (position == FrontViewPositionLeft) { // Menu is closed
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.view.userInteractionEnabled = YES;
    }
}

-(void) callAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getAllVideos *request = [[getAllVideos alloc] init_getAllVideo:[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [revealLeftMenu setTarget: self.revealViewController];
        [revealLeftMenu setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0f green:247/255.0f blue:153/255.0f alpha:1.0];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    if(indexPath.row == 0)
    {   CellIdentifier = @"videoCell";  }
    else if(indexPath.row == 1)
    {   CellIdentifier = @"videoCell3"; }
    else
    {   CellIdentifier = @"videoCell2"; }
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    bizVideo *video = [dataArr objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:@"videoCell"])
    {
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:video.videoTitle];
        
        // UIImageView *img = (UIImageView*)[cell viewWithTag:2];
        // [img setImageWithURL:[NSURL URLWithString:video.vimeoUrl] placeholderImage:[UIImage imageNamed:@"default_video_big"]];
        
        UIImageView *imgMustWatch = (UIImageView*)[cell viewWithTag:3];
        [imgMustWatch setAlpha:1];
        
        if([video.videoMustWatch intValue] == 0)
        {
            [imgMustWatch setAlpha:0];
        }
        else if([video.videoMustWatch intValue] == 1)
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                [imgMustWatch setImage:[UIImage imageNamed:@"icon_mustwatch_active"]];
            }
            else
            {
                [imgMustWatch setImage:[UIImage imageNamed:@"bm_icon_mustwatch_active"]];
            }
        }
        
        UILabel *lblLength = (UILabel*)[cell viewWithTag:4];
        [lblLength setText:video.videoDuration];
        
        UIWebView *webView = (UIWebView*)[cell viewWithTag:101];
        
        NSString *urlAddress = [NSString stringWithFormat:@"http://player.vimeo.com/video/%@", video.vimeoId];
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        webView.delegate = self;
        [webView loadRequest:request];
        
        UIButton *btnShowMore = (UIButton*)[cell viewWithTag:15];
        
    }
    else if([CellIdentifier isEqualToString:@"videoCell2"])
    {
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:video.videoTitle];
        
        UIImageView *img = (UIImageView*)[cell viewWithTag:2];
        [img setImageWithURL:[NSURL URLWithString:video.vimeoUrl] placeholderImage:[UIImage imageNamed:@"default_video_small"]];
        
        UIImageView *imgMustWatch = (UIImageView*)[cell viewWithTag:3];
        [imgMustWatch setAlpha:1];
        
        if([video.videoMustWatch intValue] == 0)
        {
            [imgMustWatch setAlpha:0];
        }
        else if([video.videoMustWatch intValue] == 1)
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                [imgMustWatch setImage:[UIImage imageNamed:@"icon_mustwatch_active"]];
            }
            else
            {
                [imgMustWatch setImage:[UIImage imageNamed:@"bm_icon_mustwatch_active"]];
            }
        }
        
        UILabel *lblLength = (UILabel*)[cell viewWithTag:4];
        [lblLength setText:video.videoDuration];
    }
    else if([CellIdentifier isEqualToString:@"videoCell3"])
    {
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:video.videoTitle];
        
        UIImageView *img = (UIImageView*)[cell viewWithTag:2];
        [img setImageWithURL:[NSURL URLWithString:video.vimeoUrl] placeholderImage:[UIImage imageNamed:@"default_video_small"]];
        
        UIImageView *imgMustWatch = (UIImageView*)[cell viewWithTag:3];
        [imgMustWatch setAlpha:1];
        
        if([video.videoMustWatch intValue] == 0)
        {
            [imgMustWatch setAlpha:0];
        }
        else if([video.videoMustWatch intValue] == 1)
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                [imgMustWatch setImage:[UIImage imageNamed:@"icon_mustwatch_active"]];
            }
            else
            {
                [imgMustWatch setImage:[UIImage imageNamed:@"bm_icon_mustwatch_active"]];
            }
        }
        
        UILabel *lblLength = (UILabel*)[cell viewWithTag:4];
        [lblLength setText:video.videoDuration];
    }
    
    return cell;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

-(UIImage *)generateThumbImage : (NSString *)filepath
{
    NSURL *url = [NSURL URLWithString:filepath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedVideoIndex = indexPath.row;
    
    if(selectedVideoIndex != 0)
    {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        [temp addObject: [dataArr objectAtIndex: selectedVideoIndex]];
        
        for(int i = 0; i < dataArr.count; i++)
        {
            if(i == selectedVideoIndex){    continue;   }
            else{       [temp addObject: [dataArr objectAtIndex: i]];   }
        }
        
        dataArr = [[NSMutableArray alloc] init];
                
        for(int i = 0; i < temp.count; i++)
        {
            [dataArr addObject: [temp objectAtIndex:i]];
        }
        
        [tblVideo reloadData];
    }
    
    // [self performSegueWithIdentifier:@"videoDetailsSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        if(screenWidth == 320 || screenWidth == 375)
        {
            return 269.0f;
        }
    }
    else if(indexPath.row == 1)
    {
        return 122.0f;
    }
    
    return 78.0f;
}

#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getVideos"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                NSArray *tempArr = [responseMessage objectForKey:@"data"];
                
                dataArr = [[NSMutableArray alloc] init];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    bizVideo *video = [[bizVideo alloc] init];
                    
                    [video setVideoId:[[tempArr objectAtIndex:i] objectForKey:@"video_id"]];
                    [video setVideoTitle:[[tempArr objectAtIndex:i] objectForKey:@"video_title"]];
                    [video setVideoDescription:[[tempArr objectAtIndex:i] objectForKey:@"video_description"]];
                    [video setVideoMustWatch:[[tempArr objectAtIndex:i] objectForKey:@"must_watch"]];
                    [video setVideoUrl:[[tempArr objectAtIndex:i] objectForKey:@"video_url"]];
                    [video setVideoDuration:[[tempArr objectAtIndex:i] objectForKey:@"duration"]];
                    [video setVimeoId:[video.videoUrl substringFromIndex:17]];
                    [video setVimeoUrl:[self CallService:[video.videoUrl substringFromIndex:17]]];
                    
                    [dataArr addObject:video];
                }
                
                [tblVideo reloadData];
            }
            
            // [SVProgressHUD dismiss];
        }
    }
    else
    {
        NSLog(@"error :- videoView");
        
        [SVProgressHUD dismiss];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"videoDetailsSegue"])
    {
        videoDetailsView *SegueController = (videoDetailsView*)[segue destinationViewController];
        SegueController.video = [dataArr objectAtIndex:selectedVideoIndex];
    }
    else if([[segue identifier]isEqualToString:@"gotoNotificationSegue"])
    {
        bizChild *child = [[bizChild alloc] init];
        [child setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        notificationView *SegueController = (notificationView*)[segue destinationViewController];
        SegueController.child_passBy = child;
    }
}

- (IBAction)home:(id)sender
{
    mainMenuView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
    
    [self.navigationController pushViewController:mmvc animated:YES];
}

-(NSString*)CallService:(NSString*)videoId
{
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://vimeo.com/api/v2/video/%@.json", videoId]]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // NSLog(@"json : %@", [[json objectAtIndex:0] objectForKey:@"thumbnail_large"]);
        
        return [[json objectAtIndex:0] objectForKey:@"thumbnail_large"];
        
    }

    return @"";
}

@end
