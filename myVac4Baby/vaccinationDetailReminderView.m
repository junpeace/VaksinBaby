//
//  vaccinationDetailReminderView.m
//  myVac4Baby
//
//  Created by jun on 11/14/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "vaccinationDetailReminderView.h"

@interface vaccinationDetailReminderView ()

@end

@implementation vaccinationDetailReminderView

@synthesize imgMonth, obj;
@synthesize dataArr;
@synthesize tblVaccine;
@synthesize child;
@synthesize imgUpdate;
@synthesize doseTakenArr;
@synthesize btnSubmit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
}

-(void) viewWillAppear:(BOOL)animated
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.title = child.childName;
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

/*
-(void)viewDidLayoutSubviews
{
    // set table inset
    
    if ([tblVaccine respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblVaccine setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblVaccine respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblVaccine setLayoutMargins:UIEdgeInsetsZero];
    }
}
*/

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [imgMonth setImage:[UIImage imageNamed:[self get2ndNotificationImage_en:obj.month]]];
    }
    else
    {
        [imgMonth setImage:[UIImage imageNamed:[self get2ndNotificationImage_en:obj.month]]];
        // [imgMonth setImage:[UIImage imageNamed:[self get2ndNotificationImage_ms:obj.month]]];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.monthWidthConstraint.constant = screenWidth;
    self.tblWidthConstraint.constant = screenWidth;
    
    [self callAPI];
}

-(void) callAPI
{    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    // get vaccines
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
        
    getVaccinesForSecondReminder *request = [[getVaccinesForSecondReminder alloc] init_getVaccinesForSecondReminder:[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] strIds:obj.vaccineIds strMonth:obj.month strChildId:child.childId];
    
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
    static NSString *CellIdentifier = @"vaccineCell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    bizVaccine *vaccine = [dataArr objectAtIndex:indexPath.row];
    
    UILabel *lblName = (UILabel*)[cell viewWithTag:1];
    [lblName setText:vaccine.name];
    
    UILabel *lblSubtitle = (UILabel*)[cell viewWithTag:2];
    [lblSubtitle setText:vaccine.subTitle];
    
    UIButton *btnYes = (UIButton*)[cell viewWithTag:3];
    UIButton *btnNo = (UIButton*)[cell viewWithTag:4];
    UIButton *btnLater = (UIButton*)[cell viewWithTag:5];
    
    [btnYes addTarget:self action:@selector(yesFunction:) forControlEvents:UIControlEventTouchUpInside];
    [btnNo addTarget:self action:@selector(noFunction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLater addTarget:self action:@selector(laterFunction:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        if([vaccine.doseStatus intValue] == 1)
        {
            [btnYes setImage:[UIImage imageNamed:@"btn_yes_active"] forState:UIControlStateNormal];
        }
        else if([vaccine.doseStatus intValue] == -1)
        {
            [btnNo setImage:[UIImage imageNamed:@"btn_no_active"] forState:UIControlStateNormal];
        }
        else if([vaccine.doseStatus intValue] == -2)
        {
            [btnLater setImage:[UIImage imageNamed:@"btn_later_active"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if([vaccine.doseStatus intValue] == 1)
        {
            [btnYes setImage:[UIImage imageNamed:@"bm_btn_yes_active"] forState:UIControlStateNormal];
        }
        else if([vaccine.doseStatus intValue] == -1)
        {
            [btnNo setImage:[UIImage imageNamed:@"bm_btn_no_active"] forState:UIControlStateNormal];
        }
        else if([vaccine.doseStatus intValue] == -2)
        {
            [btnLater setImage:[UIImage imageNamed:@"bm_btn_later_active"] forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"scheduleDoseSegue"])
    {
        doseScheduleView *SegueController = (doseScheduleView*)[segue destinationViewController];
        SegueController.child = child;
        SegueController.vaccine = [dataArr objectAtIndex:selectedIndex];
    }
}

-(NSString*) get2ndNotificationImage_en :(NSString*)monthName
{
    NSString *strImgName = @"";
    
    // base on language selection
    
    if([monthName isEqualToString:@"At Birth"])
    {
        strImgName = @"vaccine_atbirth_1";
    }
    else if([monthName isEqualToString:@"1 Month"])
    {
        strImgName = @"vaccine_1months_1";
    }
    else if([monthName isEqualToString:@"2 Month"])
    {
        strImgName = @"vaccine_2months_1";
    }
    else if([monthName isEqualToString:@"3 Month"])
    {
        strImgName = @"vaccine_3months_1";
    }
    else if([monthName isEqualToString:@"5 Month"])
    {
        strImgName = @"vaccine_5months_1";
    }
    else if([monthName isEqualToString:@"6 Month"])
    {
        strImgName = @"vaccine_6months_1";
    }
    else if([monthName isEqualToString:@"9 Month"])
    {
        strImgName = @"vaccine_9months_1";
    }
    else if([monthName isEqualToString:@"12 Month"])
    {
        strImgName = @"vaccine_12months_1";
    }
    else if([monthName isEqualToString:@"18 Month"])
    {
        strImgName = @"vaccine_18months_1";
    }
    else if([monthName isEqualToString:@"21 Month"])
    {
        strImgName = @"vaccine_21months_1";
    }
    else if([monthName isEqualToString:@"24 Month"])
    {
        strImgName = @"vaccine_24months_1";
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

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getVaccinesByIds"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                NSArray *tempArr = [responseMessage objectForKey:@"data"];
                
                dataArr = [[NSMutableArray alloc] init];
                                
                for(int i = 0; i < tempArr.count; i++)
                {
                    bizVaccine *vaccine = [[bizVaccine alloc] init];
                    [vaccine setName: [self getVaccineDisplayName:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_name"]]];
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
                
                [self updateTableHeight:dataArr.count];
                
                [tblVaccine reloadData];
                
                if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
                {
                    [imgUpdate setImage:[UIImage imageNamed:@"bm_graphics_updateneeded"]];
                }
                
                [imgUpdate setAlpha:1];
                [tblVaccine setAlpha:1];
            }
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getVaccinesForSecondReminder"])
        {
            NSArray *tempArr = [responseMessage objectForKey:@"data"];
            
            dataArr = [[NSMutableArray alloc] init];
            doseTakenArr = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < tempArr.count; i++)
            {
                bizVaccine *vaccine = [[bizVaccine alloc] init];
                [vaccine setName: [self getVaccineDisplayName:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_name"]]];
                [vaccine setVaccineId:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_id"]];
                [vaccine setSubTitle: [[tempArr objectAtIndex:i] objectForKey:@"vaccine_subTitle"]];
                [vaccine setDoseNo: [[tempArr objectAtIndex:i] objectForKey:@"dose_no"]];
                [vaccine setDoseStatus: [[tempArr objectAtIndex:i] objectForKey:@"dose_status"]];

                [dataArr addObject:vaccine];
                [doseTakenArr addObject:[[tempArr objectAtIndex:i] objectForKey:@"dose_status"]];
            }
            
            [self updateTableHeight:dataArr.count];
            
            [tblVaccine reloadData];
            
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                [imgUpdate setImage:[UIImage imageNamed:@"bm_graphics_updateneeded"]];
            }
            
            [imgUpdate setAlpha:1];
            [tblVaccine setAlpha:1];
            [btnSubmit setAlpha:1];            
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"updateVaccineCardSecondReminder"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Thank You")
                                                                  message:LocalizedString(@"Your child's vaccination status has been updated.") delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Ooops!")
                                                                  message:[responseMessage objectForKey:@"message"] delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
            }
        }
    }
    
    [SVProgressHUD dismiss];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    bizVaccine *vaccine = [dataArr objectAtIndex:indexPath.row];
    
    if([vaccine.name length] > 22)
    {
        return 70.0f;
    }
    
    return 50.0f;
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50.0f;
}

-(void) updateTableHeight :(int) count
{
    int extra = count - 2;
    
    if(count > 0)
    {
        int addOn = extra * 60;
        
        self.tblHeightConstraint.constant += addOn;
    }
}

-(NSString*) getVaccineDisplayName :(NSString*)vaccineName
{
    NSString *str = @"";
    
    if([vaccineName isEqualToString:@"BCG"])
    {   str = @"BCG";   }
    else if([vaccineName isEqualToString:@"Hepatitis B"])
    {   str = @"Hep B"; }
    else if([vaccineName isEqualToString:@"Diphtheria, Tetanus, Pertussis (DTP)"] || [vaccineName isEqualToString:@"Difteria, Kancing Gigi, Batuk Kokol Asel (DTaP)"])
    {   str = @"DTP";  }
    else if([vaccineName isEqualToString:@"Polio"])
    {   str = @"Polio";  }
    else if([vaccineName isEqualToString:@"Haemophilus influenzae type b"] || [vaccineName isEqualToString:@"Haemophilus influenzae jenis b"])
    {   str = @"Hib";  }
    else if([vaccineName isEqualToString:@"Measles (Sabah only)"])
    {   str = @"Measles";  }
    else if([vaccineName isEqualToString:@"Japanese Encephalitis (JE)"])
    {   str = @"JE";  }
    else if([vaccineName isEqualToString:@"Measles, Mumps, Rubella (MMR)"] || [vaccineName isEqualToString:@"Demam Campak, Beguk, Rubela (MMR)"])
    {   str = @"MMR";  }
    else if([vaccineName isEqualToString:@"Demam Campak (Sabah sahaja)"])
    {   str = @"Demam Campak";  }
    
    return str;
}

-(void)laterFunction:(UIButton*)sender
{
    CGPoint boundsCenter = CGRectOffset(sender.bounds, sender.frame.size.width/2, sender.frame.size.height/2).origin;
    CGPoint buttonPosition = [sender convertPoint:boundsCenter toView:tblVaccine];
    
    NSIndexPath *indexPath = [tblVaccine indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [tblVaccine cellForRowAtIndexPath:indexPath];
    
    UIButton *btnYes = (UIButton*)[cell viewWithTag:3];
    UIButton *btnNo = (UIButton*)[cell viewWithTag:4];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [btnYes setImage:[UIImage imageNamed:@"btn_yes"] forState:UIControlStateNormal];
        [btnNo setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
    }
    else
    {
        [btnYes setImage:[UIImage imageNamed:@"bm_btn_yes"] forState:UIControlStateNormal];
        [btnNo setImage:[UIImage imageNamed:@"bm_btn_no"] forState:UIControlStateNormal];
    }
    
    UIButton *btnLater = (UIButton*)[cell viewWithTag:5];
    
    if([btnLater.imageView.image isEqual:[UIImage imageNamed:@"btn_later_active"]] || [btnLater.imageView.image isEqual:[UIImage imageNamed:@"bm_btn_later_active"]])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        { [btnLater setImage:[UIImage imageNamed:@"btn_later"] forState:UIControlStateNormal]; }
        else{ [btnLater setImage:[UIImage imageNamed:@"bm_btn_later"] forState:UIControlStateNormal]; }
        
        [doseTakenArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        { [btnLater setImage:[UIImage imageNamed:@"btn_later_active"] forState:UIControlStateNormal]; }
        else{ [btnLater setImage:[UIImage imageNamed:@"bm_btn_later_active"] forState:UIControlStateNormal]; }
        
        [doseTakenArr replaceObjectAtIndex:indexPath.row withObject:@"-2"];
    }
}

-(void)noFunction:(UIButton*)sender
{
    CGPoint boundsCenter = CGRectOffset(sender.bounds, sender.frame.size.width/2, sender.frame.size.height/2).origin;
    CGPoint buttonPosition = [sender convertPoint:boundsCenter toView:tblVaccine];
    
    NSIndexPath *indexPath = [tblVaccine indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [tblVaccine cellForRowAtIndexPath:indexPath];
    
    UIButton *btnYes = (UIButton*)[cell viewWithTag:3];
    UIButton *btnLater = (UIButton*)[cell viewWithTag:5];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [btnYes setImage:[UIImage imageNamed:@"btn_yes"] forState:UIControlStateNormal];
        [btnLater setImage:[UIImage imageNamed:@"btn_later"] forState:UIControlStateNormal];
    }
    else
    {
        [btnYes setImage:[UIImage imageNamed:@"bm_btn_yes"] forState:UIControlStateNormal];
        [btnLater setImage:[UIImage imageNamed:@"bm_btn_later"] forState:UIControlStateNormal];
    }
    
    UIButton *btnNo = (UIButton*)[cell viewWithTag:4];
    
    if([btnNo.imageView.image isEqual:[UIImage imageNamed:@"btn_no_active"]] || [btnNo.imageView.image isEqual:[UIImage imageNamed:@"bm_btn_no_active"]])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        { [btnNo setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal]; }
        else{ [btnNo setImage:[UIImage imageNamed:@"bm_btn_no"] forState:UIControlStateNormal]; }
        
        [doseTakenArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        { [btnNo setImage:[UIImage imageNamed:@"btn_no_active"] forState:UIControlStateNormal]; }
        else{ [btnNo setImage:[UIImage imageNamed:@"bm_btn_no_active"] forState:UIControlStateNormal]; }
        
        [doseTakenArr replaceObjectAtIndex:indexPath.row withObject:@"-1"];
    }
}

-(void)yesFunction:(UIButton*)sender
{
    CGPoint boundsCenter = CGRectOffset(sender.bounds, sender.frame.size.width/2, sender.frame.size.height/2).origin;
    CGPoint buttonPosition = [sender convertPoint:boundsCenter toView:tblVaccine];
    
    NSIndexPath *indexPath = [tblVaccine indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [tblVaccine cellForRowAtIndexPath:indexPath];
    
    UIButton *btnYes = (UIButton*)[cell viewWithTag:3];
    
    if([btnYes.imageView.image isEqual:[UIImage imageNamed:@"btn_yes_active"]] || [btnYes.imageView.image isEqual:[UIImage imageNamed:@"bm_btn_yes_active"]])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        { [btnYes setImage:[UIImage imageNamed:@"btn_yes"] forState:UIControlStateNormal]; }
        else{ [btnYes setImage:[UIImage imageNamed:@"bm_btn_yes"] forState:UIControlStateNormal]; }
        
        [doseTakenArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        { [btnYes setImage:[UIImage imageNamed:@"btn_yes_active"] forState:UIControlStateNormal]; }
        else{ [btnYes setImage:[UIImage imageNamed:@"bm_btn_yes_active"] forState:UIControlStateNormal]; }
        
        [doseTakenArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    
    UIButton *btnNo = (UIButton*)[cell viewWithTag:4];
    UIButton *btnLater = (UIButton*)[cell viewWithTag:5];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [btnNo setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
        [btnLater setImage:[UIImage imageNamed:@"btn_later"] forState:UIControlStateNormal];
    }
    else
    {
        [btnNo setImage:[UIImage imageNamed:@"bm_btn_no"] forState:UIControlStateNormal];
        [btnLater setImage:[UIImage imageNamed:@"bm_btn_later"] forState:UIControlStateNormal];
    }
}

- (IBAction)submit:(id)sender
{
    // if all is 0, prompt a message urging the user to set at least 1 status
    
    int doseIsNotZero = 0;
    
    for(int i = 0; i < doseTakenArr.count; i++)
    {
        if([[doseTakenArr objectAtIndex:i] intValue] != 0)
        {
            doseIsNotZero = 1;
            
            break;
        }
    }
    
    if(doseIsNotZero == 0)
    {
        // set different language display text
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {     LocalizationSetLanguage(@"en"); }
        else
        {  LocalizationSetLanguage(@"ms"); }
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Important")
                                                          message:LocalizedString(@"Please select a dose's status to update") delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        return;
    }
    
    [self updateDoseStatus];
}

-(void) updateDoseStatus
{
    NSMutableArray *listOfDose = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < dataArr.count; i++)
    {
        bizVaccine *vaccine = [dataArr objectAtIndex:i];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:[NSString stringWithFormat:@"%@", vaccine.name] forKey:@"vaccineName"];
        [dic setObject:[NSString stringWithFormat:@"%@", vaccine.vaccineId] forKey:@"vaccineId"];
        [dic setObject:[NSString stringWithFormat:@"%@", vaccine.doseNo] forKey:@"doseNo"];
        [dic setObject:[NSString stringWithFormat:@"%@", [doseTakenArr objectAtIndex:i]] forKey:@"doseStatus"];
        
        [listOfDose addObject:dic];
    }
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    updateVaccineCardSecondReminders *request = [[updateVaccineCardSecondReminders alloc] init_updateVaccineCardSecondReminders:child.childId vaccineDoseList:listOfDose];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
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
