//
//  selectEmployerView.m
//  myVac4Baby
//
//  Created by Jun on 14/11/8.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "selectEmployerView.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface selectEmployerView ()

@end

@implementation selectEmployerView

@synthesize dataArr, tblEmployer;
@synthesize employer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [tblEmployer setSeparatorColor:[UIColor colorWithRed:102.0/255.0f green:172/255.0f blue:244/255.0f alpha:1.0]];
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
    
    if ([tblEmployer respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblEmployer setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblEmployer respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblEmployer setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == nil){
        
        // when user press on back button
        
        if(selectedIndex != -1)
        {
            [self.myDelegate userHasSelectedEmployer:[dataArr objectAtIndex:selectedIndex]];
        }
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    selectedIndex = -1;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"registrationEmployer";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"registrationEmployer_receiveNotification"
                                               object:nil];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"registrationEmployer_receiveNotification"])
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

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    self.title = LocalizedString(@"Employer");
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    // choose base on language selection
    
    dataArr = [[NSMutableArray alloc] init];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [dataArr addObject:@"Government Sector"];
        [dataArr addObject:@"Private Sector"];
        [dataArr addObject:@"Home Maker"];
        [dataArr addObject:@"Unemployed"];
    }
    else
    {
        [dataArr addObject:@"Kerajaan"];
        [dataArr addObject:@"Swasta"];
        [dataArr addObject:@"Perniagaan Sendiri"];
        [dataArr addObject:@"Tidak Bekerja"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"employerCell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    UILabel *lblName = (UILabel*)[cell viewWithTag:1];
    [lblName setText:[dataArr objectAtIndex:indexPath.row]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(![employer isEqualToString:@""])
    {
        if([[dataArr objectAtIndex:indexPath.row] isEqualToString:employer])
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
    if(![employer isEqualToString:@""])
    {
        [tblEmployer cellForRowAtIndexPath:pathSelected].accessoryType = UITableViewCellAccessoryNone;
        
        employer = @"";
    }
    
    // NSLog(@"selected index : %d", indexPath.row);
    
    selectedIndex = indexPath.row;
    
    [tblEmployer cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    // show the selected arrow for 0.1 second only then back to previous view
    [self performSelector:@selector(backToPreviousView) withObject:nil afterDelay:0.1];
}

-(void) backToPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblEmployer cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
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
