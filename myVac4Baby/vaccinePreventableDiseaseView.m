//
//  vaccinePreventableDiseaseView.m
//  myVac4Baby
//
//  Created by Jun on 14/10/28.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "vaccinePreventableDiseaseView.h"

@interface vaccinePreventableDiseaseView ()

@end

@implementation vaccinePreventableDiseaseView

@synthesize revealLeftMenu;
@synthesize dataArr;
@synthesize tblVaccinePreventableDisease;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self customSetup];
    
    [self performSelector:@selector(callAPI) withObject:nil afterDelay:1];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"vaccinePreventableDisease_receiveNotification"])
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
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }

    self.navigationItem.title = LocalizedString(@"Vaccine-Preventable Diseases");
    
    self.revealViewController.delegate = (id)self;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"vaccinePreventableDisease";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"vaccinePreventableDisease_receiveNotification"
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set table inset
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    // set table inset
    
    if ([tblVaccinePreventableDisease respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblVaccinePreventableDisease setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblVaccinePreventableDisease respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblVaccinePreventableDisease setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0f;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void) callAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getAllVaccinePreventableDiseases *request = [[getAllVaccinePreventableDiseases alloc] init_getAllVaccinePreventableDiseases:[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedVideoIndex = indexPath.row;
        
    [self performSegueWithIdentifier:@"vaccineDetailSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"vaccineDetailSegue"])
    {
        vaccinePreventableDeseaseDetailsView *SegueController = (vaccinePreventableDeseaseDetailsView*)[segue destinationViewController];
        SegueController.vaccine = [dataArr objectAtIndex:selectedVideoIndex];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"vaccineCell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    bizPreventableDiseases *vaccine = [dataArr objectAtIndex:indexPath.row];
    
    UILabel *lblName = (UILabel*)[cell viewWithTag:1];
    [lblName setFont:[UIFont fontWithName:@"STYuanti-SC-Regular" size:19]];
    
    NSRange range = [vaccine.preventableDiseaseName rangeOfString:@"("];
    
    if (range.location == NSNotFound)
    {
        // italice text
        NSRange range2_1 = [vaccine.preventableDiseaseName rangeOfString:@"Haemophilus Influenzae"];
        
        if (range2_1.location != NSNotFound)
        {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:vaccine.preventableDiseaseName];
            [string addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:19] range:NSMakeRange(0, 22)];
            [lblName setAttributedText: string];
        }
        else
        {
            [lblName setText:vaccine.preventableDiseaseName];
        }
    }
    else
    {
        NSRange range2 = [vaccine.preventableDiseaseName rangeOfString:@")"];
        
        if (range.location != NSNotFound)
        {
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:vaccine.preventableDiseaseName];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0/255.0f green:172/255.0f blue:244/255.0f alpha:1.0] range:NSMakeRange(range.location, range2.location - range.location + 1)];
            
            [lblName setAttributedText: string];
        }
    }
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_arrow_3"]];
    
    [cell setNeedsUpdateConstraints];//test
    [cell updateConstraintsIfNeeded];//test
    
    return cell;
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
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getVaccinePreventableDisease"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                NSArray *tempArr = [responseMessage objectForKey:@"data"];
                
                dataArr = [[NSMutableArray alloc] init];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    bizPreventableDiseases *vaccine = [[bizPreventableDiseases alloc] init];
                    
                    [vaccine setPreventableDiseaseId:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_id"]];
                    [vaccine setPreventableDiseaseName:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_name"]];
                    [vaccine setPreventableDiseaseUrl:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_description_link"]];
                    
                    // https://s3-ap-southeast-1.amazonaws.com/myvac4baby/vpd_pdf/CHICKENPOX.pdf
                    // https://s3-ap-southeast-1.amazonaws.com/myvac4baby/vpd_pdf/DIPHTHERIA.pdf
                    
                    [dataArr addObject:vaccine];
                }
            }
            
            [tblVaccinePreventableDisease reloadData];
            
            tblVaccinePreventableDisease.separatorColor = [UIColor colorWithRed:102.0/255.0f green:172/255.0f blue:244/255.0f alpha:1.0];
            
            [tblVaccinePreventableDisease setAlpha:1];
            
            [SVProgressHUD dismiss];
        }
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
