//
//  notificationViewLeftMenu.m
//  myVac4Baby
//
//  Created by jun on 2/16/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "notificationViewLeftMenu.h"

@interface notificationViewLeftMenu ()

@end

@implementation notificationViewLeftMenu

@synthesize monthArr;
@synthesize tbl2ndNotification;
@synthesize lblBubbleTitle, lblBubbleDetail;
@synthesize registerScrollView;
@synthesize secondNotificationView;
@synthesize firstNotificationView;
@synthesize lblBubbleTitle1st, lblBubbleDetail1st;
@synthesize imgSecondNotificationChild, imgFirstNotificationChild;
@synthesize tblNIP, nipArr;
@synthesize lblNA;
@synthesize imgNoReminder;
@synthesize lblAC, lblNIP;
@synthesize child_passBy;
@synthesize lblTitle24MonthsFromTop;
@synthesize tblAdditionalVaccines;
@synthesize revealLeftMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(proceedExecution) withObject:nil afterDelay:1];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"receivedReminder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self customSetup];
    
    [self setUpView];
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = LocalizedString(@"Auto Reminders");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.registerContentWidthConstraint.constant = screenWidth;
    
    if(screenWidth < 760)
    {
        self.secondNotificationTableWidthConstraint.constant = screenWidth;
        self.notificationSecondContentWidthConstraint.constant = screenWidth;
        
        self.firstNotificationViewWidthConstraint.constant = screenWidth;
    }
    
    fromAdditonalVaccine = 0;
    fromAdditonalVaccine_selectedIndex = 0;
}

-(void) proceedExecution
{
    latestNotification *notification = [[latestNotification alloc] init];
    
    NSArray *arr = [notification retrieveLatestNotificationByChildId:child_passBy.childId];
    
    if(arr.count == 1)
    {
        [imgNoReminder setAlpha:0];
        
        notificationObj = [arr objectAtIndex:0];
        
        [self setUpReminderNotification];
    }
    else
    {
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        { [imgNoReminder setImage:[UIImage imageNamed:@"bm_default_noreminder"]]; }
        
        [imgNoReminder setAlpha:1];
    }
}

-(void) setUpReminderNotification
{
    // testing
    // 1st notification id range from 1 - 11
    // 2nd notification id range from 1 - 10
    // fewer shot cell - 3, 8
    // AD month - 2, 3, 6, 7, 8
    
    notificationObj.notificationId = @"11";
    NSLog(@"notificationObj.notificationId : after : %@", notificationObj.notificationId);
    
    if ([notificationObj.notificationType isEqualToString:@"1"])
    {
        [firstNotificationView setAlpha:1];
        [self setUpReminderTable_1stNotification];
        [self changeNIP_AC_img];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"receivedReminder"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([notificationObj.notificationType isEqualToString:@"2"])
    {
        [secondNotificationView setAlpha:1];
        [self setUpReminderTable1_2ndNotification];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"receivedReminder"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{ /* error - notification type out of range */ }
}

-(void) changeNIP_AC_img
{
    /* set different image for different language preference */
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [lblNIP setImage:[UIImage imageNamed:@"bm_label_nationalimmunisationprogramme"]];
        [lblAC setImage:[UIImage imageNamed:@"bm_label_additionalvaccines_horizontal"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(tableView == tbl2ndNotification)
    {
        return [monthArr count];
    }
    else if(tableView == tblAdditionalVaccines)
    {
        if([notificationObj.notificationId isEqualToString:@"8"] || [notificationObj.notificationId isEqualToString:@"3"])
        {
            /* 2 months || 12 months */
            
            return 2;
        }
        
        return 1;
    }
    else
    {
        return [nipArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    if(tableView == tbl2ndNotification)
    {
        CellIdentifier = @"notification2ndCell";
    }
    else if(tableView == tblNIP)
    {
        CellIdentifier = @"notification1stCell";
        
        /* decide which cell to use */
        
        if(indexPath.row + 1 == [nipArr count])
        {
            bizReminderFirstNotificationNip *nip = [nipArr objectAtIndex:indexPath.row];
            
            if ([nip.nipId isEqualToString:@"10000"])
            { CellIdentifier = @"fewerShotCell"; }
        }
        
        if([notificationObj.notificationId isEqualToString:@"11"])
        {
            if(indexPath.row == 0){     CellIdentifier = @"lastMonthCell2";     }
            else if(indexPath.row == 1){    CellIdentifier = @"lastMonthCell1";     }
            else if(indexPath.row == 2){    CellIdentifier = @"lastMonthCell3";     }
            else if(indexPath.row == 3){    CellIdentifier = @"lastMonthCell4";     }
        }
    }
    else if(tableView == tblAdditionalVaccines)
    {
        /* before notification object has been initialize any value */
        
        CellIdentifier = @"emptyCell";
        
        if([notificationObj.notificationId isEqualToString:@"2"])
        { CellIdentifier = @"oneMonthCell"; }
        else if([notificationObj.notificationId isEqualToString:@"3"])
        {
            if(indexPath.row == 0) { CellIdentifier = @"twoMonthCell1"; }
            else { CellIdentifier = @"twoMonthCell2"; }
        }
        else if([notificationObj.notificationId isEqualToString:@"6"])
        { CellIdentifier = @"sixMonthCell"; }
        else if([notificationObj.notificationId isEqualToString:@"7"])
        { CellIdentifier = @"nineMonthCell"; }
        else if([notificationObj.notificationId isEqualToString:@"8"])
        {
            if(indexPath.row == 0){ CellIdentifier = @"twelfMonthCell1"; }
            else{ CellIdentifier = @"twelfMonthCell2"; }
        }
    }
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(tableView == tbl2ndNotification)
    {
        bizReminderSecondNotificationMonth *obj = [monthArr objectAtIndex:indexPath.row];
        
        UIImageView *imgMonth = (UIImageView*)[cell viewWithTag:1];
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {  [imgMonth setImage:[UIImage imageNamed:[self get2ndNotificationImage_en:obj.month]]]; }
        else{  [imgMonth setImage:[UIImage imageNamed:[self get2ndNotificationImage_ms:obj.month]]]; }
        
        UIImageView *imgNotification = (UIImageView*)[cell viewWithTag:2];
        
        if(indexPath.row == (monthArr.count-1))
        { [imgNotification setAlpha:1]; }
        else{ [imgNotification setAlpha:0]; }
    }
    else if(tableView == tblNIP)
    {
        if([CellIdentifier isEqualToString:@"fewerShotCell"])
        {
            bizReminderFirstNotificationNip *nip = [nipArr objectAtIndex:indexPath.row];
            
            UILabel *lblName = (UILabel*)[cell viewWithTag:1];
            [lblName setText:nip.nipTitle];
            
            UILabel *lblTtitle = (UILabel*)[cell viewWithTag:2];
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Looking for Fewer Shot?"];
            [attributeString addAttribute:NSUnderlineStyleAttributeName
                                    value:[NSNumber numberWithInt:1]
                                    range:(NSRange){0,[attributeString length]}];
            
            [lblTtitle setAttributedText:attributeString];
            
            // remove baby image
            // UIImageView *imgFrontBaby = (UIImageView*)[cell viewWithTag:3];
            // [imgFrontBaby setImage:[UIImage imageNamed:@"icon_vaccine_2"]];
        }
        else if([CellIdentifier isEqualToString:@"lastMonthCell1"] || [CellIdentifier isEqualToString:@"lastMonthCell2"] ||
                [CellIdentifier isEqualToString:@"lastMonthCell3"] || [CellIdentifier isEqualToString:@"lastMonthCell4"])
        {
            return cell;
        }
        else
        {
            bizReminderFirstNotificationNip *nip = [nipArr objectAtIndex:indexPath.row];
            
            UILabel *lblName = (UILabel*)[cell viewWithTag:1];
            
            [lblName setAttributedText:[self getFirstNotificationFormattedTitle: nip.nipTitle: indexPath]];
            
            UIImageView *imgFrontBaby = (UIImageView*)[cell viewWithTag:2];
            
            if(indexPath.row + 1 == [nipArr count])
            {
                [imgFrontBaby setImage:[UIImage imageNamed:@"icon_vaccine_2"]];
            }
            else
            {
                if(indexPath.row + 2 == [nipArr count])
                {
                    /* check if last item is fewer shot cell */
                    
                    bizReminderFirstNotificationNip *nip = [nipArr objectAtIndex:indexPath.row + 1];
                    
                    if ([nip.nipId isEqualToString:@"10000"])
                    {       [imgFrontBaby setImage:[UIImage imageNamed:@"icon_vaccine_2"]];     }
                    else{   [imgFrontBaby setImage:[UIImage imageNamed:@"icon_vaccine_1"]];    }
                    
                    /* end of checking */
                }
                else
                {       [imgFrontBaby setImage:[UIImage imageNamed:@"icon_vaccine_1"]];     }
            }
        }
    }
    else if(tableView == tblAdditionalVaccines)
    {
        /* 1 month || 6 months || 9 months */
        
        NSMutableAttributedString *attributeString;
        
        if([notificationObj.notificationId isEqualToString:@"2"])
        {
            UILabel *lblDesc = (UILabel*)[cell viewWithTag:1];
            
            attributeString = [[NSMutableAttributedString alloc] initWithString:lblDesc.text];
            
            [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
            [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(69, 2)];
            
            [lblDesc setAttributedText:attributeString];
        }
        else if([notificationObj.notificationId isEqualToString:@"3"])
        {
            if(indexPath.row == 0)
            {
                UILabel *lblDesc = (UILabel*)[cell viewWithTag:1];
                
                attributeString = [[NSMutableAttributedString alloc] initWithString:lblDesc.text];
                [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
                
                [lblDesc setAttributedText:attributeString];
            }
            else if(indexPath.row == 1)
            {
                UILabel *lblDesc = (UILabel*)[cell viewWithTag:1];
                
                attributeString = [[NSMutableAttributedString alloc] initWithString:lblDesc.text];
                [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
                [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(65, 2)];
                
                [lblDesc setAttributedText:attributeString];
            }
        }
        else if([notificationObj.notificationId isEqualToString:@"7"])
        {
            UILabel *lblDesc = (UILabel*)[cell viewWithTag:1];
            
            attributeString = [[NSMutableAttributedString alloc] initWithString:lblDesc.text];
            [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
            
            [lblDesc setAttributedText:attributeString];
        }
        else if([notificationObj.notificationId isEqualToString:@"8"])
        {
            if(indexPath.row == 0)
            {
                UILabel *lblDesc = (UILabel*)[cell viewWithTag:1];
                
                attributeString = [[NSMutableAttributedString alloc] initWithString:lblDesc.text];
                [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
                
                [lblDesc setAttributedText:attributeString];
            }
            else if(indexPath.row == 1)
            {
                UILabel *lblDesc = (UILabel*)[cell viewWithTag:1];
                
                attributeString = [[NSMutableAttributedString alloc] initWithString:lblDesc.text];
                [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
                [attributeString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(28, 2)];
                
                [lblDesc setAttributedText:attributeString];
            }
        }
    }
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index path : %d", indexPath.row);
    
    if(tableView == tbl2ndNotification)
    {
        selectedMonthIndex = indexPath.row;
        
        [self performSegueWithIdentifier:@"secondReminderSegue" sender:nil];
    }
    else if(tableView == tblNIP)
    {
        bizReminderFirstNotificationNip *nip = [nipArr objectAtIndex:indexPath.row];
        
        if (![nip.nipId isEqualToString:@"10000"])
        {
            selectedNipIndex = indexPath.row;
            
            [self performSegueWithIdentifier:@"nipSegue" sender:nil];
        }
    }
    else if(tableView == tblAdditionalVaccines)
    {
        fromAdditonalVaccine = 1;
        fromAdditonalVaccine_selectedIndex = indexPath.row;
        
        [self performSegueWithIdentifier:@"nipSegue" sender:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == tbl2ndNotification)
    {
        return 49.0f;
    }
    else if(tableView == tblAdditionalVaccines)
    {
        if([notificationObj.notificationId isEqualToString:@"2"])
        {
            /* 1 month */
            
            return 195.0f;
        }
        else if([notificationObj.notificationId isEqualToString:@"3"])
        {
            /* 2 month */
            
            if(indexPath.row == 0){ return 160.0f; }
            else{ return 230.0f; }
        }
        else if([notificationObj.notificationId isEqualToString:@"7"])
        {
            /* 9 months */
            
            return 170.0f;
        }
        else if([notificationObj.notificationId isEqualToString:@"8"])
        {
            /* 12 months */
            
            return 80.0f;
        }
        else
        {
            return 110.0f;
        }
    }
    else
    {
        bizReminderFirstNotificationNip *nip = [nipArr objectAtIndex:indexPath.row];
        
        if ([nip.nipId isEqualToString:@"10000"])
        { return 130.0f; }
        
        if([notificationObj.notificationId isEqualToString:@"11"])
        {
            if(indexPath.row == 1)
            {   return 30.0f;   }
            else if(indexPath.row == 2 || indexPath.row == 3)
            {   return 54.0f;   }
        }
        
        return 40.0f;
    }
}

-(void) setUpReminderTable_1stNotification
{
    [self getFirstNotificationData];
}

-(void) getFirstNotificationData
{
    firstNotification *notification = [[firstNotification alloc] init];
    
    NSArray *arr;
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        LocalizationSetLanguage(@"en");
        
        arr = [notification retrieveFirstNotificationById: notificationObj.notificationId];
    }
    else
    {
        LocalizationSetLanguage(@"ms");
        
        arr = [notification retrieveFirstNotificationById_ms: notificationObj.notificationId];
    }
    
    if([arr count] > 0)
    {
        bizFirstNotification *biz = [arr objectAtIndex:0];
        
        // NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:biz.notificationTitle];
        // [attributeString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:(NSRange){0,[attributeString length]}];
        // [lblBubbleTitle1st setAttributedText:attributeString];
        
        [lblBubbleDetail1st setAttributedText:[self getFirstNotificationBubleDetailMsg]];
        
        [imgFirstNotificationChild setImageWithURL:[NSURL URLWithString:child_passBy.childImageUrl] placeholderImage:[UIImage imageNamed:@"default_1streminder_child.png"]];
        imgFirstNotificationChild.layer.cornerRadius = imgFirstNotificationChild.frame.size.height / 2;
        imgFirstNotificationChild.layer.masksToBounds = YES;
        imgFirstNotificationChild.layer.borderWidth = 0;
        
        nipArr = [[NSMutableArray alloc] init];
        
        NSArray *titleArr = [biz.vaccineTitle componentsSeparatedByString:@";"];
        NSArray *idArr = [biz.fkVaccinePreventableDiseaseId componentsSeparatedByString:@";"];
        NSArray *urlArr = [biz.preventableDiseaseDescUrl componentsSeparatedByString:@";"];
        
        for(int i = 0; i < titleArr.count; i++)
        {
            bizReminderFirstNotificationNip *nip = [[bizReminderFirstNotificationNip alloc] init];
            
            [nip setNipId:[idArr objectAtIndex:i]];
            [nip setNipTitle:[titleArr objectAtIndex:i]];
            [nip setNipUrl:[urlArr objectAtIndex:i]];
            
            [nipArr addObject:nip];
        }
        
        
        
        
        if([notificationObj.notificationId isEqualToString:@"3"])
        {
            /* 2 months fewer shot */
            bizReminderFirstNotificationNip *nip = [[bizReminderFirstNotificationNip alloc] init];
            
            [nip setNipId:@"10000"];
            [nip setNipTitle:@"6-in-1 Combination Vaccine: DTP, Polio, Hib, Hep B - ask your doctor for more information & the scedule"];
            [nip setNipUrl:@""];
            
            [nipArr addObject:nip];
        }
        else if([notificationObj.notificationId isEqualToString:@"8"])
        {
            /* 12 months fewer shot */
            bizReminderFirstNotificationNip *nip = [[bizReminderFirstNotificationNip alloc] init];
            
            [nip setNipId:@"10000"];
            [nip setNipTitle:@"4-in-1 Combination Vaccine: MMR - VAricella - ask your doctor for more information & the scedule"];
            [nip setNipUrl:@""];
            
            [nipArr addObject:nip];
        }
        
        
        
        
        
        // check if show NA label or AV table
        
        if([notificationObj.notificationId isEqualToString:@"2"] || [notificationObj.notificationId isEqualToString:@"3"] || [notificationObj.notificationId isEqualToString:@"6"] || [notificationObj.notificationId isEqualToString:@"7"] || [notificationObj.notificationId isEqualToString:@"8"])
        {
            /* 1 month || 2 months || 6 months || 9 months */
            
            [tblAdditionalVaccines reloadData];
            [lblNA setAlpha:0];
        }
        else if([notificationObj.notificationId isEqualToString:@"11"])
        {
            /* last months */
            
            lblTitle24MonthsFromTop.constant = 2;
            [tblAdditionalVaccines setAlpha:0];
            [lblNA setAlpha:1];
        }
        else
        {
            [tblAdditionalVaccines setAlpha:0];
            [lblNA setAlpha:1];
        }
    }
    
    [self updateFirstNotificationTableHeight:nipArr.count];
    
    [tblNIP reloadData];
}

-(NSAttributedString*) getFirstNotificationBubleDetailMsg
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    { LocalizationSetLanguage(@"en"); }
    else
    { LocalizationSetLanguage(@"ms"); }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
    
    switch ([notificationObj.notificationId intValue])
    {
        case 0:
            break;
            
        case 1:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 0 months old. \nI need these vaccines: \"")];
            break;
            
        case 2:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 1 months old. \nI need these vaccines: \"")];
            break;
            
        case 3:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 2 months old. \nI need these vaccines: \"")];
            break;
            
        case 4:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 3 months old. \nI need these vaccines: \"")];
            break;
            
        case 5:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 5 months old. \nI need these vaccines: \"")];
            break;
            
        case 6:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 6 months old. \nI need these vaccines: \"")];
            break;
            
        case 7:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 9 months old. \nI need these vaccines: \"")];
            break;
            
        case 8:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 12 months old. \nI need these vaccines: \"")];
            break;
            
        case 9:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 18 months old. \nI need these vaccines: \"")];
            break;
            
        case 10:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" I am going to be 21 months old. \nI need these vaccines: \"")];
            break;
            
        case 11:
            attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"\" Thank you for remembering my vaccination to date. For my continued protection, I will need the following shots in the coming years. \"")];
            break;
            
        default:
            break;
    }
    
    
    
    // no longer need it
    // check language preference, bi and bm operation will be different
    
    /*NSRange range = [[attributeString string] rangeOfString:@"at"];
    
    if (range.location != NSNotFound) {
        
        NSRange range2 = [[attributeString string] rangeOfString:@"."];
        
        if (range2.location != NSNotFound) {
            
            [attributeString addAttribute:NSUnderlineStyleAttributeName
                                    value:[NSNumber numberWithInt:1]
                                    range:(NSRange){range.location, [[[attributeString string] substringWithRange:NSMakeRange(range.location, range2.location - range.location)] length]}];
        }
    }*/
    
    
    
    
    return attributeString;
}

-(void) updateFirstNotificationTableHeight :(int) count
{
    self.tblNipHeightConstraint.constant = 40;
    self.firstNotificationViewHeightConstraint.constant = 470;
    self.tblAdditionalVaccineHeightConstraint.constant = 80;
    
    // add 45.0f for extra 1
    
    int extra = count - 1;
    
    if(extra > 0)
    {
        int addition = extra * 45;
        
        self.tblNipHeightConstraint.constant += addition - 3;
        
        self.firstNotificationViewHeightConstraint.constant += addition;
    }
    
    /* for fewer shot */
    
    if([notificationObj.notificationId isEqualToString:@"3"] || [notificationObj.notificationId isEqualToString:@"8"])
    {
        int extraLine = 2;
        
        int addition = extraLine * 40;
        
        self.tblNipHeightConstraint.constant += addition - 3;
        
        self.firstNotificationViewHeightConstraint.constant += addition;
        
        if([notificationObj.notificationId isEqualToString:@"8"])
        {
            /* increase height for Additional Vaccine table & 1st notification scroll view */
            
            self.tblNipHeightConstraint.constant += 15;
            
            self.tblAdditionalVaccineHeightConstraint.constant += 80;
            
            self.firstNotificationViewHeightConstraint.constant += 60;
        }
        else if([notificationObj.notificationId isEqualToString:@"3"])
        {
            /* increase height for Additional Vaccine table & 1st notification scroll view */
            
            self.tblNipHeightConstraint.constant += 10;
            
            self.tblAdditionalVaccineHeightConstraint.constant += 310;
            
            self.firstNotificationViewHeightConstraint.constant += 290;
        }
    }
    else if([notificationObj.notificationId isEqualToString:@"6"])
    {
        /* increase height for Additional Vaccine table */
        
        self.tblAdditionalVaccineHeightConstraint.constant += 20;
    }
    else if([notificationObj.notificationId isEqualToString:@"7"])
    {
        /* increase height for Additional Vaccine table & 1st notification scroll view */
        
        self.tblAdditionalVaccineHeightConstraint.constant += 80;
        
        self.firstNotificationViewHeightConstraint.constant += 60;
    }
    else if([notificationObj.notificationId isEqualToString:@"2"])
    {
        /* increase height for Additional Vaccine table & 1st notification scroll view */
        
        self.tblAdditionalVaccineHeightConstraint.constant += 110;
        
        self.firstNotificationViewHeightConstraint.constant += 90;
    }
    else if([notificationObj.notificationId isEqualToString:@"11"])
    {
        /* increase height for Additional Vaccine table & 1st notification scroll view */
        
        self.tblNipHeightConstraint.constant += 5;
        
        self.tblAdditionalVaccineHeightConstraint.constant += 5;
        
        self.firstNotificationViewHeightConstraint.constant += 5;
    }
}

-(void) setUpReminderTable1_2ndNotification
{
    if(monthArr.count > 0){ return; }
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    //NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"VACCINATION TRACKER UPDATES :")];
    //[attributeString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:(NSRange){0,[attributeString length]}];
    //[lblBubbleTitle setAttributedText:attributeString];
    
    [lblBubbleDetail setText:LocalizedString(@"\"Please update my vaccinations under the National Immunisation Programme below. For Additional Vaccines, please update my Vaccination Tracker manually.\"")];
    
    [imgSecondNotificationChild setImageWithURL:[NSURL URLWithString:child_passBy.childImageUrl] placeholderImage:[UIImage imageNamed:@"default_1streminder_child.png"]];
    imgSecondNotificationChild.layer.cornerRadius = imgSecondNotificationChild.frame.size.height / 2;
    imgSecondNotificationChild.layer.masksToBounds = YES;
    imgSecondNotificationChild.layer.borderWidth = 0;
    
    monthArr = [[NSMutableArray alloc] init];
    
    [self getSecondNotificationData];
    
    [self updateSecondNotificationTableHeight:monthArr.count];
    
    [tbl2ndNotification reloadData];
}

-(void) getSecondNotificationData
{
    secondNotification *notification = [[secondNotification alloc] init];
    
    NSArray *arr;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        arr = [notification retrieveSecondNotificationById: notificationObj.notificationId];
    }
    else
    {
        arr = [notification retrieveSecondNotificationById_ms: notificationObj.notificationId];
    }
    
    if([arr count] > 0)
    {
        bizSecondNotification *biz = [arr objectAtIndex:0];
        
        NSArray *months = [biz.vaccineTimes componentsSeparatedByString:@";"];
        
        NSError *e;
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [biz.fkVaccineIds dataUsingEncoding:NSUTF8StringEncoding]  options: NSJSONReadingMutableContainers error: &e];
        
        for(int i = 0; i < months.count; i++)
        {
            bizReminderSecondNotificationMonth *obj = [[bizReminderSecondNotificationMonth alloc] init];
            
            [obj setMonth:[months objectAtIndex:i]];
            [obj setVaccineIds:[JSON objectForKey:[months objectAtIndex:i]]];
            
            [monthArr addObject:obj];
        }
    }
}

-(void) updateSecondNotificationTableHeight :(int) count
{
    // add 49.0f for extra 1
    
    int extra = count - 4;
    
    if(extra > 0)
    {
        int additon = extra * 49;
        
        self.tblSecondNotificationHeight.constant += additon - 30;
        
        self.notificationSecondHeightConstraint.constant += additon;
    }
}

-(NSString*) get2ndNotificationImage_en :(NSString*)monthName
{
    NSString *strImgName = @"";
    
    // base on language selection
    
    if([monthName isEqualToString:@"At Birth"])
    {
        strImgName = @"vaccine_atbirth";
    }
    else if([monthName isEqualToString:@"1 Month"])
    {
        strImgName = @"vaccine_1months";
    }
    else if([monthName isEqualToString:@"2 Month"])
    {
        strImgName = @"vaccine_2months";
    }
    else if([monthName isEqualToString:@"3 Month"])
    {
        strImgName = @"vaccine_3months";
    }
    else if([monthName isEqualToString:@"5 Month"])
    {
        strImgName = @"vaccine_5months";
    }
    else if([monthName isEqualToString:@"6 Month"])
    {
        strImgName = @"vaccine_6months";
    }
    else if([monthName isEqualToString:@"9 Month"])
    {
        strImgName = @"vaccine_9months";
    }
    else if([monthName isEqualToString:@"12 Month"])
    {
        strImgName = @"vaccine_12months";
    }
    else if([monthName isEqualToString:@"18 Month"])
    {
        strImgName = @"vaccine_18months";
    }
    else if([monthName isEqualToString:@"21 Month"])
    {
        strImgName = @"vaccine_21months";
    }
    else if([monthName isEqualToString:@"24 Month"])
    {
        strImgName = @"vaccine_24months";
    }
    
    return strImgName;
}

-(NSString*) get2ndNotificationImage_ms :(NSString*)monthName
{
    NSString *strImgName = @"";
    
    // base on language selection
    // month name will be in malay if not mistaken
    
    if([monthName isEqualToString:@"Ketika Lahir"])
    {
        strImgName = @"bm_vaccine_atbirth";
    }
    else if([monthName isEqualToString:@"1 Bulan"])
    {
        strImgName = @"bm_vaccine_1months";
    }
    else if([monthName isEqualToString:@"2 Bulan"])
    {
        strImgName = @"bm_vaccine_2months";
    }
    else if([monthName isEqualToString:@"3 Bulan"])
    {
        strImgName = @"bm_vaccine_3months";
    }
    else if([monthName isEqualToString:@"5 Bulan"])
    {
        strImgName = @"bm_vaccine_5months";
    }
    else if([monthName isEqualToString:@"6 Bulan"])
    {
        strImgName = @"vaccine_6months";
    }
    else if([monthName isEqualToString:@"9 Bulan"])
    {
        strImgName = @"bm_vaccine_9months";
    }
    else if([monthName isEqualToString:@"12 Bulan"])
    {
        strImgName = @"bm_vaccine_12months";
    }
    else if([monthName isEqualToString:@"18 Bulan"])
    {
        strImgName = @"bm_vaccine_18months";
    }
    else if([monthName isEqualToString:@"21 Bulan"])
    {
        strImgName = @"bm_vaccine_21months";
    }
    else if([monthName isEqualToString:@"24 Bulan"])
    {
        strImgName = @"bm_vaccine_24months";
    }
    
    return strImgName;
}


-(NSMutableAttributedString*) getFirstNotificationFormattedTitle :(NSString*) title :(NSIndexPath*) indexPath
{
    NSMutableAttributedString *attributedStr;
    
    switch ([notificationObj.notificationId intValue])
    {
        case 1:
            
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"BCG - Single Dose"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 1 - BCG Untuk Tibi"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 3)];
                }
            }
            else if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hep B - Dose 1"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 5)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 1 - Hep B"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 5)];
                }
            }
            
            break;
            
        case 2:
            
            /* 1 month only got 1 NIP, no verification needed */
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hep B - Dose 2"];
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 5)];
            }
            else
            {
                attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 2 - Hep B"];
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 5)];
            }
            
            break;
            
        case 3:
            
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"DTP - Dose 1"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 1 - DTP"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 3)];
                }
            }
            else if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Polio - Dose 1"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 5)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 1 - Polio"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 5)];
                }
            }
            else if(indexPath.row == 2)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hib - Dose 1"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 1 - Hib"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 3)];
                }
            }
            
            break;
            
        case 4:
            
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"DTP - Dose 2"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"DTP - Dose 2"];
                }
            }
            else if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Polio - Dose 2"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 5)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Polio - Dose 2"];
                }
            }
            else if(indexPath.row == 2)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hib - Dose 2"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hib - Dose 2"];
                }
            }
            
            break;
            
        case 5:
            
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"DTP - Dose 3"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"DTP - Dose 3"];
                }
            }
            else if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Polio - Dose 3"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 5)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Polio - Dose 3"];
                }
            }
            else if(indexPath.row == 2)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hib - Dose 3"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hib - Dose 3"];
                }
            }
            
            break;
            
        case 6:
            
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hep B - Dose 3"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 5)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 3 - Hep B"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:18] range:NSMakeRange(0, [attributedStr length])];
                }
            }
            else if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Measley - Dose 1 (Sabah only)"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 5)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 1 - Demam Campak(Sabah)"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:18] range:NSMakeRange(0, [attributedStr length])];
                }
            }
            
            break;
            
        case 7:
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                attributedStr = [[NSMutableAttributedString alloc] initWithString:@"JE - Dose 1 (Sarawak only)"];
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 2)];
            }
            else
            {
                attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 2 - JE (Sarawak)"];
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 2)];
            }
            
            break;
            
        case 8:
            
            /* 12 month only got 1 NIP, no verification needed */
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                attributedStr = [[NSMutableAttributedString alloc] initWithString:@"MMR - Dose 1"];
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
            }
            else
            {
                attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 1 - MMR"];
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 3)];
            }
            
            break;
            
        case 9:
            
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"DTP - Booster Dose"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos Tambahan - DTP"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(15, 3)];
                }
            }
            else if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"POLIO - Booster Dose"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 5)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos Tambahan - POLIO"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(15, 5)];
                }
            }
            else if(indexPath.row == 2)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Hib - Booster Dose"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos Tambahan - Hib"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(15, 3)];
                }
            }
            
            break;
            
        case 10:
            
            /* 21 month only got 1 NIP, no verification needed */
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                attributedStr = [[NSMutableAttributedString alloc] initWithString:@"JE - Dose 2 (Sarawak only)"];
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(0, 2)];
            }
            else
            {
                attributedStr = [[NSMutableAttributedString alloc] initWithString:@"Dos 2 - JE (Sarawak)"];
                [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(8, 2)];
            }
            
            break;
            
        case 11:
            
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"7 years - DT - Booster Dose"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(10, 2)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"7 years - DT - Booster Dose"];
                }
            }
            else if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"7 years - Measles & Rubella - Dose 2"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(10, 17)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"7 years - Measles & Rubella - Dose 2"];
                }
            }
            else if(indexPath.row == 2)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"13 years - HPV - 2 doses"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(12, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"13 years - HPV - 2 doses"];
                }
            }
            else if(indexPath.row == 3)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"15 years - Tetanus - Booster Dose"];
                    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STYuanti-SC-Bold" size:19] range:NSMakeRange(12, 3)];
                }
                else
                {
                    attributedStr = [[NSMutableAttributedString alloc] initWithString:@"15 years - Tetanus - Booster Dose"];
                }
            }
            
            break;
            
        default:
            break;
    }
    
    return attributedStr;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"secondReminderSegue"])
    {
        // notification details
        
        bizChild *child = [[bizChild alloc] init];
        [child setChildId: notificationObj.childId];
        [child setChildImageUrl: notificationObj.childImgUrl];
        
        // loop throught the list of child and get the child's name
        NSArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"childArr"];
        
        for(int i = 0; i < temp.count; i++)
        {
            if([[[temp objectAtIndex:i] objectForKey:@"childId"] intValue] == [child.childId intValue])
            {
                [child setChildName:[[temp objectAtIndex:i] objectForKey:@"name"]];
                break;
            }
        }
        
        vaccinationDetailReminderView *SegueController = (vaccinationDetailReminderView*)[segue destinationViewController];
        SegueController.obj = [monthArr objectAtIndex:selectedMonthIndex];
        SegueController.child = child;
    }
    else if([[segue identifier]isEqualToString:@"vtDetailSegue"])
    {
        // vaccinationTrackerDetailView *SegueController = (vaccinationTrackerDetailView*)[segue destinationViewController];
        // SegueController.child = [childArr objectAtIndex:selectedChildIndex];
    }
    else if([[segue identifier]isEqualToString:@"nipSegue"])
    {
        if(fromAdditonalVaccine == 0)
        {
            nipDetailView *SegueController = (nipDetailView*)[segue destinationViewController];
            SegueController.nip = [nipArr objectAtIndex:selectedNipIndex];
        }
        else if(fromAdditonalVaccine == 1)
        {
            bizReminderFirstNotificationNip *nip = [[bizReminderFirstNotificationNip alloc] init];
            nip.nipTitle = @"";
            nip.nipUrl = @"";
            
            if([notificationObj.notificationId isEqualToString:@"2"])
            {
                nip.nipTitle = @"Rotavirus";
                nip.nipUrl = @"http://54.251.175.250/MyVac4Baby/vaksin_html/Instructions%20Each%20box%20represents%20one%20Vaccine%20Page/Rotavirus.html";
            }
            else if([notificationObj.notificationId isEqualToString:@"3"])
            {
                if(fromAdditonalVaccine_selectedIndex == 0)
                {
                    nip.nipTitle = @"Pneumococcal Vaccine";
                    nip.nipUrl = @"http://54.251.175.250/MyVac4Baby/vaksin_html/Instructions%20Each%20box%20represents%20one%20Vaccine%20Page/Pneumococcal%20Disease.html";
                }
                else if(fromAdditonalVaccine_selectedIndex == 1)
                {
                    nip.nipTitle = @"Meningococcal Vaccine";
                    nip.nipUrl = @"http://54.251.175.250/MyVac4Baby/vaksin_html/Instructions%20Each%20box%20represents%20one%20Vaccine%20Page/Meningococcal%20Disease.html";
                }
            }
            else if([notificationObj.notificationId isEqualToString:@"6"])
            {
                nip.nipTitle = @"Influenza";
                nip.nipUrl = @"http://54.251.175.250/MyVac4Baby/vaksin_html/Instructions%20Each%20box%20represents%20one%20Vaccine%20Page/Influenza.html";
            }
            else if([notificationObj.notificationId isEqualToString:@"7"])
            {
                nip.nipTitle = @"Meningococcal Vaccine";
                nip.nipUrl = @"http://54.251.175.250/MyVac4Baby/vaksin_html/Instructions%20Each%20box%20represents%20one%20Vaccine%20Page/Meningococcal%20Disease.html";
            }
            else if([notificationObj.notificationId isEqualToString:@"8"])
            {
                if(fromAdditonalVaccine_selectedIndex == 0)
                {
                    nip.nipTitle = @"Hep A";
                    nip.nipUrl = @"http://54.251.175.250/MyVac4Baby/vaksin_html/Instructions%20Each%20box%20represents%20one%20Vaccine%20Page/Hepatitis%20A.html";
                }
                else if(fromAdditonalVaccine_selectedIndex == 1)
                {
                    nip.nipTitle = @"Chickenpox (Varicella)";
                    nip.nipUrl = @"http://54.251.175.250/MyVac4Baby/vaksin_html/Instructions%20Each%20box%20represents%20one%20Vaccine%20Page/Chickenpox%20(Varicella).html";
                }
            }
            
            nipDetailView *SegueController = (nipDetailView*)[segue destinationViewController];
            SegueController.nip = nip;
        }
    }
}

@end
