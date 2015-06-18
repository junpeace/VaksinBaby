//
//  leftMenuTableView.m
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "leftMenuTableView.h"

@implementation SWUITableViewCell
@end

@interface leftMenuTableView ()

@end

@implementation leftMenuTableView

@synthesize dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setupLeftMenu];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_sidemenu"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    //[self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
}

-(void) viewWillDisappear:(BOOL)animated
{
    //[self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

-(void) setupLeftMenu
{
    loginStatus = 0;
    numberOfChild = 0;
    
    NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
    
    if (password != nil)
    {
        // Logged in
        loginStatus = 200;
    }
    
    dataArr = [[NSMutableArray alloc] init];
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"4", @"type", LocalizedString(@"Auto Reminders (Register Child)"), @"name", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"type", LocalizedString(@"Vaccination Tracker"), @"name", nil];
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"type", @"Videos", @"name", nil];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"type", LocalizedString(@"Vaccine-Preventable Diseases"), @"name", nil];
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"type", LocalizedString(@"Other Resources"), @"name", nil];
    NSDictionary *dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"type", LocalizedString(@"Report Adverse Effect"), @"name", nil];
    NSDictionary *dict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"9", @"type", LocalizedString(@"Logout"), @"name", nil];
    NSDictionary *dict16 = [NSDictionary dictionaryWithObjectsAndKeys:@"8", @"type", LocalizedString(@"Terms & Conditions"), @"name", nil];
    NSDictionary *dict15 = [NSDictionary dictionaryWithObjectsAndKeys:@"5", @"type", LocalizedString(@"Take The Tour"), @"name", nil];
    NSDictionary *dict14 = [NSDictionary dictionaryWithObjectsAndKeys:@"7", @"type", LocalizedString(@"Select Language"), @"name", nil];
    NSDictionary *dict9 = [NSDictionary dictionaryWithObjectsAndKeys:@"10", @"type", LocalizedString(@"Add Child"), @"name", nil];
    
    // user logged in
    if(loginStatus == 200)
    {
        NSDictionary *dict10 = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"type", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], @"name", nil];
        [dataArr addObject:dict10];
        
        temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"childArr"];
        
        // add child into side menu
        if(temp.count > 0){
            for(int i = 0; i < temp.count; i++)
            {
                [dataArr addObject:[temp objectAtIndex:i]];
            }
            
            numberOfChild = temp.count;
        }
    }
    else
    {
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"6", @"type", LocalizedString(@"Login"), @"name", nil];
        [dataArr addObject:dict1];
    }
    
    [dataArr addObject:dict9];
    [dataArr addObject:dict2];
    [dataArr addObject:dict3];
    [dataArr addObject:dict4];
    [dataArr addObject:dict5];
    [dataArr addObject:dict6];
    [dataArr addObject:dict7];
    [dataArr addObject:dict14];
    [dataArr addObject:dict15];
    [dataArr addObject:dict16];
    
    // user logged in
    if(loginStatus == 200){
        // add logout option
        [dataArr addObject:dict8]; }
    
    [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell;
    
    if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 1)
    {
        CellIdentifier = @"normal";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setFont:[UIFont fontWithName:@"STYuanti-SC-Light" size:18]];
        
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Login"] || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Daftar Masuk"])
        {
            [lblName setFont:[UIFont fontWithName:@"STYuanti-SC-Bold" size:18]];
        }
                
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        [lblName setTextColor:[UIColor colorWithRed:57.0/255.0f green:96/255.0f blue:161/255.0f alpha:1.0]];
        
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Vaccination Tracker"] 
           || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Rekod Vaksinasi"])
        {
            if(loginStatus != 200){ [lblName setTextColor:[UIColor colorWithRed:168.0/255.0f green:165/255.0f blue:165/255.0f alpha:1.0]]; }
        }
        else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Report Adverse Effect"] || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Lapor Kesan Sampingan"])
        {
            if(loginStatus != 200){ [lblName setTextColor:[UIColor colorWithRed:168.0/255.0f green:165/255.0f blue:165/255.0f alpha:1.0]]; }
        }
    }
    else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 2)
    {
        CellIdentifier = @"withImage";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:2];
        [lblName setFont:[UIFont fontWithName:@"STYuanti-SC-Light" size:18]];
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
                
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:3];
        imgView.layer.cornerRadius = imgView.frame.size.height / 2;
        imgView.layer.masksToBounds = YES;
        imgView.layer.borderWidth = 0;
        imgView.clipsToBounds = YES;
        imgView.layer.borderWidth = 1.0f;
        imgView.layer.borderColor = [UIColor whiteColor].CGColor;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        [imgView setImageWithURL:[NSURL URLWithString:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"default_addaphotoofyourbaby"]];
        
    }
    else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 3)
    {
        CellIdentifier = @"withButton";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:4];
        [lblName setFont:[UIFont fontWithName:@"STYuanti-SC-Bold" size:18]];
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:6];
        [imgView setAlpha:1];
        
        // if(numberOfChild == 0){ [imgView setAlpha:0]; }
    }
    else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 4)
    {
        CellIdentifier = @"reminderCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Auto Reminders (Register Child)"])
        {
             NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
             [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Light" size:18] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(0, 14)];
             [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Light" size:14] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(15, 16)];
            
             [lblName setAttributedText:attributeString];
        }
        
        if(loginStatus == 200){ [lblName setTextColor:[UIColor colorWithRed:57.0/255.0f green:96/255.0f blue:161/255.0f alpha:1.0]]; }
        else{ [lblName setTextColor:[UIColor colorWithRed:168.0/255.0f green:165/255.0f blue:165/255.0f alpha:1.0]]; }
        
        UIImageView *imgNotification = (UIImageView*)[cell viewWithTag:3];
        
        UILabel *lblNotification = (UILabel*)[cell viewWithTag:4];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"receivedReminder"])
        { [imgNotification setAlpha:1]; [lblNotification setAlpha:1]; }
        else
        { [imgNotification setAlpha:0]; [lblNotification setAlpha:0]; }
    }
    else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 5)
    {        
        CellIdentifier = @"tourCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setFont:[UIFont fontWithName:@"STYuanti-SC-Light" size:18]];
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    }
    else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 6)
    {
        CellIdentifier = @"titleCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setFont:[UIFont fontWithName:@"STYuanti-SC-Bold" size:18]];
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:2];
        [imgView setAlpha:0];
        
        if(numberOfChild != 0){ [imgView setAlpha:1]; }
    }
    else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 7)
    {
        CellIdentifier = @"languageSelectedCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    }
    else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 8)
    {
        CellIdentifier = @"tncCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:2];
        [imgView setAlpha:0];
        
        if(loginStatus != 200){     [imgView setAlpha:1];   }
    }
    else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 9)
    {
        CellIdentifier = @"logoutCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    }
    else
    {
        CellIdentifier = @"addChildCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:2];
        [imgView setAlpha:0];
        
        if(loginStatus == 200)
        {   [lblName setTextColor:[UIColor colorWithRed:57.0/255.0f green:96/255.0f blue:161/255.0f alpha:1.0]]; }
        else
        {
            [imgView setAlpha:1];
            [lblName setTextColor:[UIColor colorWithRed:168.0/255.0f green:165/255.0f blue:165/255.0f alpha:1.0]]; }
    }
    
    // print out how to call custom font
    // NSLog(@" %@", [UIFont fontNamesForFamilyName:@"Yuanti SC"]);
    
    return cell;
}

-(void) addChild
{
    [self performSegueWithIdentifier:@"createChildSegue" sender:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    // navigate logged in user to edit profile
    if(indexPath.row == 0){
        if(loginStatus == 200){  [self performSegueWithIdentifier:@"userProfileSegue" sender:nil]; }}
    
    if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 1)
    {
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Videos"])
        {
            [self performSegueWithIdentifier:@"videoSegue" sender:nil];
        }
        else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Vaccine-Preventable Diseases"] || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Penyakit-penyakit yang boleh dicegah dengan vaksin"])
        {
            [self performSegueWithIdentifier:@"vaccinePreventableDiseasesSegu" sender:nil];
        }
        else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Other Resources"]
                || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Sumber-sumber lain"])
        {
            [self performSegueWithIdentifier:@"otherResourcesSegue" sender:nil];
        }
        else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Report Adverse Effect"]
                || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Lapor Kesan Sampingan"])
        {
            // user didnt login
            if(loginStatus != 200){ return; }
            
            [self performSegueWithIdentifier:@"reportAdverseEffectSegue" sender:nil];
        }
        else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Take The Tour"])
        {
            [self performSegueWithIdentifier:@"takeATourSegue" sender:nil];
        }
        else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Vaccination Tracker"]
                || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Rekod Vaksinasi"])
        {
            // user didnt login
            if(loginStatus != 200){ return; }
            
            [self performSegueWithIdentifier:@"vaccinationTrackerSegue" sender:nil];
        }
        else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Login"]
                || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Daftar Masuk"])
        {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }
    else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 2)
    {
        // get selected child profile
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        filteredArray = [temp filteredArrayUsingPredicate:predicate];
        
        // Set the selected child profile
        [[NSUserDefaults standardUserDefaults] setObject:filteredArray forKey:@"SelectedChildToEditProfile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"editChildFromLeftMenu" sender:nil];
    }
    else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 4)
    {
        // user didnt login
        if(loginStatus != 200){ return; }
        
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Auto Reminders (Register Child)"]
           || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Pengingatan"])
        {
            [self performSegueWithIdentifier:@"reminderSegue" sender:nil];
        }
    }
    else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 5)
    {
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Take The Tour"] || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Buat Lawatan"])
        {
            [self performSegueWithIdentifier:@"takeATourSegue" sender:nil];
        }
    }
    else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 6)
    {
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Login"]
           || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Daftar Masuk"])
        {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }
    else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 7)
    {
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Select Language"]
                || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Pilih Bahasa"])
        {
            [self performSegueWithIdentifier:@"selectLanguageSegue" sender:nil];
        }
    }
    else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 8)
    {        
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Terms & Conditions"]
           || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Terms & Conditions"])
        {
            [self performSegueWithIdentifier:@"tncSegue" sender:nil];
        }
    }
    else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 9)
    {
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Logout"]
                || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Log keluar"])
        {
            NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
            
            if (password != nil)
            {
                // 1st row is username - log user out
                
                [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                
                // destroy password(id)
                [SSKeychain deletePasswordForService:@"myVac4Baby" account:@"anyUser"];
                
                // reset child arr
                temp = [[NSMutableArray alloc] init];
                [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"childArr"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Logged Out")
                                                                  message:LocalizedString(@"You have successfully logged out. You will still receive push notifications for your registered children.") delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
                
                [SVProgressHUD dismiss];
                
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }
    }
    else if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue] == 10)
    {
        if([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Add Child"]
                || [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"Tambah anak"])
        {
            // user didnt login
            if(loginStatus != 200){ return; }
            
            [self performSegueWithIdentifier:@"createChildSegue" sender:nil];
        }
    }
}

#pragma TableView delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
