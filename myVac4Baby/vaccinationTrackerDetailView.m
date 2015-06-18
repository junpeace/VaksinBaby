//
//  vaccinationTrackerDetailView.m
//  myVac4Baby
//
//  Created by jun on 11/5/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "vaccinationTrackerDetailView.h"

@interface vaccinationTrackerDetailView ()

@end

@implementation vaccinationTrackerDetailView

@synthesize child;
@synthesize dataArr;
@synthesize tblVaccinationTracker;
@synthesize imgAdditional, imgEssential;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self performSelector:@selector(setUpView) withObject:nil afterDelay:1];
    
    [tblVaccinationTracker setSeparatorColor:[UIColor colorWithRed:102.0/255.0f green:172/255.0f blue:244/255.0f alpha:1.0]];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"vaccinationTrackerVaccinesList_receiveNotification"])
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set table inset
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if(indexPath.row > 8)
    {
        cell.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:235.0/255.0f blue:235.0/255.0f alpha:1.0];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
}

-(void)viewDidLayoutSubviews
{
    // set table inset
    
    if ([tblVaccinationTracker respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblVaccinationTracker setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblVaccinationTracker respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblVaccinationTracker setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    NSString *str = @"";
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        str = [NSString stringWithFormat:@"%@", child.childName];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@", child.childName];
    }
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = str;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"vaccinationTrackerVaccinesList";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"vaccinationTrackerVaccinesList_receiveNotification"
                                               object:nil];
}

-(void) setUpView
{
    [self callAPI];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.widthConstraint.constant = screenWidth;
}

-(void) callAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getAllVaccines *request = [[getAllVaccines alloc] init_getAllVaccines: [[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    bizVaccine *vaccine = [dataArr objectAtIndex:indexPath.row];

    UILabel *lblName = (UILabel*)[cell viewWithTag:1];
    
    NSRange range = [vaccine.name rangeOfString:@"("];
    if (range.location == NSNotFound) {
        
        [lblName setText:vaccine.name];
    } else {
        
        NSRange range2 = [vaccine.name rangeOfString:@")"];
        
        if (range.location == NSNotFound) {
            
        }
        else
        {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:vaccine.name];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0/255.0f green:172/255.0f blue:244/255.0f alpha:1.0] range:NSMakeRange(range.location, range2.location - range.location + 1)];
            
            [lblName setAttributedText: string];
        }
    }
    
    // italice text
    NSRange range2 = [vaccine.name rangeOfString:@"Haemophilus influenzae"];
    if (range2.location != NSNotFound) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:vaccine.name];
        [string addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:19] range:NSMakeRange(0, 22)];
        
        [lblName setAttributedText: string];
    }
    
    if([vaccine.type isEqualToString:@"EV"])
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_arrow_3"]];
    }
    else
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_arrow_4"]];
    }
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected index : %d", indexPath.row);
    
    selectedVaccineIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"scheduleDoseView" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0f;
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getVaccines"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                dataArr = [[NSMutableArray alloc] init];
                
                NSMutableArray *tempArr = [responseMessage objectForKey:@"data"];
                
                NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"vaccine_type" ascending:NO];
                [tempArr sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    bizVaccine *vaccine = [[bizVaccine alloc] init];
                    [vaccine setName:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_name"]];
                    [vaccine setVaccineId:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_id"]];
                    [vaccine setSchedule:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_schedule"]];
                    [vaccine setType:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_type"]];
                    [vaccine setBooster:[[tempArr objectAtIndex:i] objectForKey:@"booster"]];
                    [vaccine setDose1:[[tempArr objectAtIndex:i] objectForKey:@"dose1"]];
                    [vaccine setDose2:[[tempArr objectAtIndex:i] objectForKey:@"dose2"]];
                    [vaccine setDose3:[[tempArr objectAtIndex:i] objectForKey:@"dose3"]];
                    [vaccine setDose4:[[tempArr objectAtIndex:i] objectForKey:@"dose4"]];
                    
                    [dataArr addObject:vaccine];
                }
                
                [tblVaccinationTracker reloadData];
                
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    [imgEssential setImage:[UIImage imageNamed:@"label_essentialvaccines"]];
                    [imgAdditional setImage:[UIImage imageNamed:@"label_additionalvaccines"]];
                }
                else
                {
                    [imgEssential setImage:[UIImage imageNamed:@"bm_label_essentialvaccines"]];
                    [imgAdditional setImage:[UIImage imageNamed:@"bm_label_additionalvaccines"]];
                }
                
                [tblVaccinationTracker setAlpha:1];
            }
        }
    }
    
    [SVProgressHUD dismiss];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"scheduleDoseView"])
    {        
        doseScheduleView *SegueController = (doseScheduleView*)[segue destinationViewController];
        SegueController.child = child;
        SegueController.vaccine = [dataArr objectAtIndex:selectedVaccineIndex];
    }
    else if([[segue identifier]isEqualToString:@"gotoNotificationSegue"])
    {
        bizChild *child_ = [[bizChild alloc] init];
        [child_ setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child_ setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        notificationView *SegueController = (notificationView*)[segue destinationViewController];
        SegueController.child_passBy = child_;
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

@end
