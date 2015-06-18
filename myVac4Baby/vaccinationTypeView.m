//
//  vaccinationTypeView.m
//  myVac4Baby
//
//  Created by Jun on 14/11/7.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "vaccinationTypeView.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

// http://stackoverflow.com/questions/19844727/objective-c-storyboards-segue-passing-data-from-destination-back-to-sourceview

@interface vaccinationTypeView ()

@end

@implementation vaccinationTypeView

@synthesize dataArr, tblVaccinationType, myDelegate;
@synthesize vaccinationType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [tblVaccinationType setSeparatorColor:[UIColor colorWithRed:102.0/255.0f green:172/255.0f blue:244/255.0f alpha:1.0]];
    
    NSLog(@"vaccination type : %@", vaccinationType);
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"reportAdversedEffectVaccines_receiveNotification"])
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

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    selectedIndex = -1;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"reportAdversedEffectVaccines";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"reportAdversedEffectVaccines_receiveNotification"
                                               object:nil];
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
    
    if ([tblVaccinationType respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblVaccinationType setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblVaccinationType respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblVaccinationType setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    self.title = LocalizedString(@"Type of Vaccination");
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    // choose base on language selection
    
    [self callAPI];
}

-(void) callAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getAllVaccines *request = [[getAllVaccines alloc] init_getAllVaccines: [[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == nil){
        
        // when user press on back button
        
        if(selectedIndex != -1)
        {
            [self.myDelegate userHasCompletedSettings:[dataArr objectAtIndex:selectedIndex]];
        }
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
    
    if(cell == nil )
    {
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    }
    
    UILabel *lblName = (UILabel*)[cell viewWithTag:1];
    [lblName setText:[dataArr objectAtIndex:indexPath.row]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(![vaccinationType isEqualToString:@""])
    {
        if([[dataArr objectAtIndex:indexPath.row] isEqualToString:vaccinationType])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            pathSelected = indexPath;
        }
    }
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![vaccinationType isEqualToString:@""])
    {
        [tblVaccinationType cellForRowAtIndexPath:pathSelected].accessoryType = UITableViewCellAccessoryNone;

        vaccinationType = @"";
    }
    
    // NSLog(@"selected index : %d", indexPath.row);
    
    selectedIndex = indexPath.row;
    
    [tblVaccinationType cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    // show the selected arrow for 0.1 second only then back to previous view
    [self performSelector:@selector(backToPreviousView) withObject:nil afterDelay:0.1];
}

-(void) backToPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblVaccinationType cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[dataArr objectAtIndex:indexPath.row] length] > 35)
    {
        return 90.0f;
    }
    
    return 49.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                for (int i = 0; i < tempArr.count; i++)
                {
                    [dataArr addObject:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_name"]];
                }
            }
            
            [tblVaccinationType reloadData];
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

@end
