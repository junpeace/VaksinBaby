//
//  selectHealthcarePreferenceView.m
//  myVac4Baby
//
//  Created by Jun on 14/11/8.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "selectHealthcarePreferenceView.h"
#import "notificationView.h"
#import "AppDelegate.h"
#import "bizChild.h"

@interface selectHealthcarePreferenceView ()

@end

@implementation selectHealthcarePreferenceView

@synthesize dataArr, tblHp;
@synthesize hp;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [tblHp setSeparatorColor:[UIColor colorWithRed:102.0/255.0f green:172/255.0f blue:244/255.0f alpha:1.0]];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    selectedIndex = -1;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"registrationHealthcare";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"registrationHealthcare_receiveNotification"
                                               object:nil];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"registrationHealthcare_receiveNotification"])
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
    
    self.title = LocalizedString(@"Healthcare Preference");
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    // choose base on language selection
    
    dataArr = [[NSMutableArray alloc] init];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [dataArr addObject:@"Government Hospital/Clinic"];
        [dataArr addObject:@"Private Hospital/Clinic"];
    }
    else
    {
        [dataArr addObject:@"Kerajaan"];
        [dataArr addObject:@"Swasta"];
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == nil){
        
        // when user press on back button
        
        if(selectedIndex != -1)
        {
            [self.myDelegate userHasSelectedHP:[dataArr objectAtIndex:selectedIndex]];
        }
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
    
    if ([tblHp respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblHp setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblHp respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblHp setLayoutMargins:UIEdgeInsetsZero];
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
    static NSString *CellIdentifier = @"hpCell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    UILabel *lblName = (UILabel*)[cell viewWithTag:1];
    [lblName setText:[dataArr objectAtIndex:indexPath.row]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(![hp isEqualToString:@""])
    {
        if([[dataArr objectAtIndex:indexPath.row] isEqualToString:hp])
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
    if(![hp isEqualToString:@""])
    {
        [tblHp cellForRowAtIndexPath:pathSelected].accessoryType = UITableViewCellAccessoryNone;
        
        hp = @"";
    }
    
    // NSLog(@"selected index : %d", indexPath.row);
    
    selectedIndex = indexPath.row;
    
    [tblHp cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    // show the selected arrow for 0.1 second only then back to previous view
    [self performSelector:@selector(backToPreviousView) withObject:nil afterDelay:0.1];
}

-(void) backToPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblHp cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
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
