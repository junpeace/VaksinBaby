//
//  vaccinationTrackerView.m
//  myVac4Baby
//
//  Created by jun on 10/31/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "vaccinationTrackerView.h"

@interface vaccinationTrackerView ()

@end

@implementation vaccinationTrackerView

@synthesize revealLeftMenu;
@synthesize lblTrackerText;
@synthesize tblVaccinationTracker;
@synthesize dataArr;
@synthesize lblNoChild;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"vaccinationTracker_receiveNotification"])
    {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    [self setupView];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self performSelector:@selector(callAPI) withObject:nil afterDelay:1];
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"vaccinationTracker";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"vaccinationTracker_receiveNotification"
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
    
    getChilds *request = [[getChilds alloc] init_getChilds:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) setupView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    lblTrackerText.text = LocalizedString(@"Click to view and update your child's vaccination records.");
    self.navigationItem.title = LocalizedString(@"Vaccination Tracker");
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"vaccinationCell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    bizChild *child = [dataArr objectAtIndex:indexPath.row];
    
    UIImageView *imgBg = (UIImageView*)[cell viewWithTag:1];
    
    if( [child.childGender caseInsensitiveCompare:@"male"] == NSOrderedSame )
    {
        [imgBg setImage:[UIImage imageNamed:@"vaccinationtracker_boy"]];
    }
    else
    {
        [imgBg setImage:[UIImage imageNamed:@"vaccinationtracker_girl"]];
    }
    
    UIImageView *imgBaby = (UIImageView*)[cell viewWithTag:2];
    imgBaby.layer.cornerRadius = imgBaby.frame.size.height / 2;
    imgBaby.layer.masksToBounds = YES;
    imgBaby.layer.borderWidth = 0;
    
    [imgBaby setImageWithURL:[NSURL URLWithString:child.childImageUrl] placeholderImage:[UIImage imageNamed:@"default_addaphotoofyourbaby"]];
    
    UILabel *lblName = (UILabel*)[cell viewWithTag:3];
    [lblName setText:child.childName];
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedChildIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"vtDetailSegue" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.0f;
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getChildByMomId"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                dataArr = [[NSMutableArray alloc] init];
                
                NSArray *tempArr = [responseMessage objectForKey:@"data"];

                for(int i = 0; i < tempArr.count; i++)
                {
                    bizChild *child = [[bizChild alloc] init];
                    [child setChildId:[[tempArr objectAtIndex:i] objectForKey:@"child_id"]];
                    [child setChildName:[[tempArr objectAtIndex:i] objectForKey:@"child_name"]];
                    [child setChildGender:[[tempArr objectAtIndex:i] objectForKey:@"child_gender"]];
                    [child setChildDateOfBirth:[[tempArr objectAtIndex:i] objectForKey:@"child_date_of_birth"]];
                    [child setChildImageUrl:[[tempArr objectAtIndex:i] objectForKey:@"child_image"]];
                    
                    [dataArr addObject:child];
                }
                
                [lblNoChild setAlpha:0];
            }
            else
            {
                // set different language display text
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {     LocalizationSetLanguage(@"en"); }
                else
                {  LocalizationSetLanguage(@"ms"); }
                
                [lblNoChild setText:LocalizedString(@"No baby at the moment")];
                [lblNoChild setAlpha:1];
            }
            
            [self updateTableHeight:dataArr.count];
            
            [tblVaccinationTracker reloadData];
            
            [tblVaccinationTracker setAlpha:1];
        }
    }
    
    [lblTrackerText setAlpha:1];
    
    [SVProgressHUD dismiss];
}

-(void) updateTableHeight :(int) count
{
    // reset table's height constraint
    self.tblHeightConstraint.constant = 180.0f;
    
    // reset view's height constrant
    self.vaccineViewHeightConstraint.constant = 600.0f;
    
    // add 90.0f for extra 1
    
    int extra = count - 2;
    
    if(extra > 0)
    {
        int additon = extra * 90;
        
        self.tblHeightConstraint.constant += additon;
        
        int extra2 = count - 4;
        
        if(extra2 > 0)
        {
            if(extra2 == 1)
            {
                self.vaccineViewHeightConstraint.constant += 30;
            }
            else
            {
                additon = (extra2 - 1) * 90;
                
                self.vaccineViewHeightConstraint.constant += additon;
            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"vtDetailSegue"])
    {
        vaccinationTrackerDetailView *SegueController = (vaccinationTrackerDetailView*)[segue destinationViewController];
        SegueController.child = [dataArr objectAtIndex:selectedChildIndex];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)home:(id)sender {
    
    mainMenuView *mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
    [self.navigationController pushViewController:mmvc animated:YES];
}
@end
