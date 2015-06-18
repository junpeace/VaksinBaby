//
//  doseScheduleView.m
//  myVac4Baby
//
//  Created by jun on 11/11/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "doseScheduleView.h"

@interface doseScheduleView ()

@end

@implementation doseScheduleView

@synthesize child;
@synthesize imgDose, imgSchedule;
@synthesize vaccine;
@synthesize lblName, imgNameBg;
@synthesize tblSchedule, scheduleArr;
@synthesize doseArr, tblDose;
@synthesize btnUpdate, btnSubmit;
@synthesize doseTakenArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imgCounter = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *str;
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        [imgSchedule setImage:[UIImage imageNamed:@"bm_tab_schedule_active"]];
        [imgDose setImage:[UIImage imageNamed:@"bm_tab_dose"]];
        
        str = [NSString stringWithFormat:@"%@", child.childName];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@", child.childName];
    }
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = str;
    
    [self performSelector:@selector(setUpView) withObject:nil afterDelay:1];
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    [btnUpdate setTitle:LocalizedString(@"Update") forState:UIControlStateNormal];
    [btnSubmit setTitle:LocalizedString(@"Submit") forState:UIControlStateNormal];
    
    NSArray *temp = [vaccine.schedule componentsSeparatedByString: @";"];
    
    scheduleArr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < temp.count; i++)
    {
        [scheduleArr addObject:[temp objectAtIndex:i]];
    }
    
    lblName.text = vaccine.name;
    
    [self performSelector:@selector(resizeLabelBgHeight) withObject:nil afterDelay:0.5];
    
    [self performSelector:@selector(getChildVaccineCard) withObject:nil afterDelay:0.5];
}

-(void) resizeLabelBgHeight
{
    if(lblName.frame.size.height > 23)
    {
        self.lblBgHeigtConstraint.constant = 75;
    }
    
    [imgNameBg setImage:[UIImage imageNamed:@"vaccine_blank"]];
    
    [lblName setTextColor:[UIColor colorWithRed:57.0/255.0f green:96.0/255.0f blue:161.0/255.0f alpha:1.0]];
    
    [tblSchedule reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(tableView == tblSchedule)
    {
        return [scheduleArr count];
    }
    else
    {
        return [doseArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    
    if(tableView == tblSchedule)
    {
        CellIdentifier = @"scheduleCell";
    }
    else if(tableView == tblDose)
    {
        CellIdentifier = @"doseCell";
        
        if([vaccine.vaccineId isEqualToString:@"10"] || [vaccine.vaccineId isEqualToString:@"11"] || [vaccine.vaccineId isEqualToString:@"12"]
           || [vaccine.vaccineId isEqualToString:@"13"] || [vaccine.vaccineId isEqualToString:@"14"] || [vaccine.vaccineId isEqualToString:@"15"])
        {
            if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"10"])
            {       CellIdentifier = @"rotavirusCell";      }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"11"])
            {       CellIdentifier = @"pneumococcalCell";   }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"12"])
            {       CellIdentifier = @"influenzaCell";   }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"13"])
            {       CellIdentifier = @"hepatitisACell";   }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"14"])
            {       CellIdentifier = @"chickenpoxCell";   }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"15"])
            {       CellIdentifier = @"meningococcalCell";   }
        }
    }
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(tableView == tblSchedule)
    {
        UILabel *lblName_ = (UILabel*)[cell viewWithTag:2];
        [lblName_ setText:[scheduleArr objectAtIndex:indexPath.row]];
    }
    else if(tableView == tblDose)
    {
        if([CellIdentifier isEqualToString:@"rotavirusCell"] || [CellIdentifier isEqualToString:@"pneumococcalCell"] || [CellIdentifier isEqualToString:@"influenzaCell"] ||
           [CellIdentifier isEqualToString:@"hepatitisACell"] || [CellIdentifier isEqualToString:@"chickenpoxCell"] || [CellIdentifier isEqualToString:@"meningococcalCell"])
        {
            if([CellIdentifier isEqualToString:@"rotavirusCell"])
            {
                UILabel *lblTitle = (UILabel*)[cell viewWithTag:1];
                
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:lblTitle.text];
                [attributedStr setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
                
                [lblTitle setAttributedText:attributedStr];
            }
            else if([CellIdentifier isEqualToString:@"pneumococcalCell"])
            {
                UILabel *lblTitle = (UILabel*)[cell viewWithTag:1];
                
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:lblTitle.text];
                [attributedStr setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
                
                [lblTitle setAttributedText:attributedStr];
            }
            else if([CellIdentifier isEqualToString:@"hepatitisACell"])
            {
                UILabel *lblTitle = (UILabel*)[cell viewWithTag:1];
                
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:lblTitle.text];
                [attributedStr setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
                
                [lblTitle setAttributedText:attributedStr];
            }
            else if([CellIdentifier isEqualToString:@"chickenpoxCell"])
            {
                UILabel *lblTitle = (UILabel*)[cell viewWithTag:1];
                
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:lblTitle.text];
                [attributedStr setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(32, 2)];
                [attributedStr setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(59, 2)];
                
                [lblTitle setAttributedText:attributedStr];
            }
            else if([CellIdentifier isEqualToString:@"meningococcalCell"])
            {
                UILabel *lblTitle = (UILabel*)[cell viewWithTag:1];
                
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:lblTitle.text];
                [attributedStr setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(1, 2)];
                [attributedStr setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:12] , NSBaselineOffsetAttributeName : @8} range:NSMakeRange(65, 2)];
                
                [lblTitle setAttributedText:attributedStr];
            }
            
            return cell;
        }
        
        bizChildVaccineCard *childVaccineCard = [doseArr objectAtIndex:indexPath.row];
        
        if([vaccine.vaccineId isEqualToString:@"10"] || [vaccine.vaccineId isEqualToString:@"11"] || [vaccine.vaccineId isEqualToString:@"12"]
           || [vaccine.vaccineId isEqualToString:@"13"] || [vaccine.vaccineId isEqualToString:@"14"] || [vaccine.vaccineId isEqualToString:@"15"])
        {
            /* vaccine belong to Additional Vaccine, no month name assign */
            
            UILabel *lblName_ = (UILabel*)[cell viewWithTag:21];
           
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {  [lblName_ setText:[self getDoseName_en:childVaccineCard.doseNo]]; }
            else{  [lblName_ setText:[self getDoseName_ms:childVaccineCard.doseNo]]; }
        }
        else
        {
            UILabel *lblName_ = (UILabel*)[cell viewWithTag:1];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {  [lblName_ setText:[self getDoseName_en:childVaccineCard.doseNo]]; }
            else{  [lblName_ setText:[self getDoseName_ms:childVaccineCard.doseNo]]; }
            
            UILabel *lblMonth = (UILabel*)[cell viewWithTag:11];
            [lblMonth setText:[NSString stringWithFormat:@"(%@)", [scheduleArr objectAtIndex:indexPath.row]]];
        }
        
        if(showDefault == 1)
        {
            UIImageView *imgStatus = (UIImageView*)[cell viewWithTag:2];
        
            switch ([childVaccineCard.status intValue]) {
                case 0:
                    [imgStatus setImage:[UIImage imageNamed:@"btn_dose"]];
                    break;
                case 1:
                    [imgStatus setImage:[UIImage imageNamed:@"btn_dose_active"]];
                    break;
                case -1:
                    [imgStatus setImage:[UIImage imageNamed:@"btn_dose_no"]];
                    break;
                case -2:
                    [imgStatus setImage:[UIImage imageNamed:@"btn_dose"]];
                    break;
                default:
                    break;
            }
            
            [imgStatus setAlpha:1];
            
            UIButton *btnYes = (UIButton*)[cell viewWithTag:3];
            [btnYes setAlpha:0];
            
            UIButton *btnNo = (UIButton*)[cell viewWithTag:4];
            [btnNo setAlpha:0];
            
            UIButton *btnLater = (UIButton*)[cell viewWithTag:5];
            [btnLater setAlpha:0];
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                [btnYes setImage:[UIImage imageNamed:@"btn_yes"] forState:UIControlStateNormal];
                [btnNo setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
                [btnLater setImage:[UIImage imageNamed:@"btn_later"] forState:UIControlStateNormal];
            }
            else
            {
                [btnYes setImage:[UIImage imageNamed:@"bm_btn_yes"] forState:UIControlStateNormal];
                [btnNo setImage:[UIImage imageNamed:@"bm_btn_no"] forState:UIControlStateNormal];
                [btnLater setImage:[UIImage imageNamed:@"bm_btn_later"] forState:UIControlStateNormal];
            }
        }
        else
        {
            UIImageView *imgStatus = (UIImageView*)[cell viewWithTag:2];
            [imgStatus setAlpha:0];
            
            UIButton *btnYes = (UIButton*)[cell viewWithTag:3];
            [btnYes setAlpha:1];
            [btnYes addTarget:self action:@selector(yesFunction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btnNo = (UIButton*)[cell viewWithTag:4];
            [btnNo setAlpha:1];
            [btnNo addTarget:self action:@selector(noFunction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btnLater = (UIButton*)[cell viewWithTag:5];
            [btnLater setAlpha:1];
            [btnLater addTarget:self action:@selector(laterFunction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
            {
                if([childVaccineCard.status intValue] == 1)
                {
                    [btnYes setImage:[UIImage imageNamed:@"btn_yes_active"] forState:UIControlStateNormal];
                }
                else if([childVaccineCard.status intValue] == -1)
                {
                    [btnNo setImage:[UIImage imageNamed:@"btn_no_active"] forState:UIControlStateNormal];
                }
                else if([childVaccineCard.status intValue] == -2)
                {
                    [btnLater setImage:[UIImage imageNamed:@"btn_later_active"] forState:UIControlStateNormal];
                }
            }
            else
            {
                if([childVaccineCard.status intValue] == 1)
                {
                    [btnYes setImage:[UIImage imageNamed:@"bm_btn_yes_active"] forState:UIControlStateNormal];
                }
                else if([childVaccineCard.status intValue] == -1)
                {
                    [btnNo setImage:[UIImage imageNamed:@"bm_btn_no_active"] forState:UIControlStateNormal];
                }
                else if([childVaccineCard.status intValue] == -2)
                {
                    [btnLater setImage:[UIImage imageNamed:@"bm_btn_later_active"] forState:UIControlStateNormal];
                }
            }
        }
    }
    
    return cell;
}

-(void)laterFunction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblDose];
    NSIndexPath *indexPath = [tblDose indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [tblDose cellForRowAtIndexPath:indexPath];
    
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

-(void)noFunction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblDose];
    NSIndexPath *indexPath = [tblDose indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [tblDose cellForRowAtIndexPath:indexPath];
    
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

-(void)yesFunction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblDose];
    NSIndexPath *indexPath = [tblDose indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"index path : %d", indexPath.row);
    
    UITableViewCell *cell = [tblDose cellForRowAtIndexPath:indexPath];
    
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

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblSchedule)
    {
        NSLog(@"selected index : %d", indexPath.row);
    }
    else if(tableView == tblDose)
    {
        NSLog(@"selected index : %d", indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == tblSchedule)
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 8)
        {
            // ios7 custom height
            if([[scheduleArr objectAtIndex:indexPath.row] length] < 25)
            {
                return 60.0f;
            }
            else if([[scheduleArr objectAtIndex:indexPath.row] length] < 55)
            {
                return 85.0f;
            }
            else if([[scheduleArr objectAtIndex:indexPath.row] length] < 75)
            {
                return 110.0f;
            }
            else if([[scheduleArr objectAtIndex:indexPath.row] length] < 100)
            {
                return 130.0f;
            }
            else
            {
                return 130.0f;
            }
        }
    }
    else if(tableView == tblDose)
    {
        if([vaccine.vaccineId isEqualToString:@"10"] || [vaccine.vaccineId isEqualToString:@"11"] || [vaccine.vaccineId isEqualToString:@"12"]
           || [vaccine.vaccineId isEqualToString:@"13"] || [vaccine.vaccineId isEqualToString:@"14"] || [vaccine.vaccineId isEqualToString:@"15"])
        {
            /* vaccine belong to Additional Vaccine, no month name assign */
            
            if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"10"])
            {       return 95.0f;       }
            else  if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"11"])
            {       return 135.0f;      }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"12"])
            {       return 70.0f;   }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"13"])
            {       return 48.0f;   }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"14"])
            {       return 110.0f;   }
            else if(indexPath.row == 0 && [vaccine.vaccineId isEqualToString:@"15"])
            {       return 160.0f;  }
        }
        else
        {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;

            if([[scheduleArr objectAtIndex:indexPath.row] isEqualToString:@"7 years (Diphtheria & Tetanus only)"])
            {
                if(screenWidth == 320)
                {    return 90.0f;   }
                else{   return 68.0f;   }
                
            }
            else if([[scheduleArr objectAtIndex:indexPath.row] isEqualToString:@"7 years (Tetanus only)"])
            {
                if(screenWidth == 320)
                {    return 90.0f;   }
                else{   return 68.0f;   }
            }
        }
        
        return 58.0f;
    }
    
    return UITableViewAutomaticDimension;
 }

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeImg:(id)sender {

    if(imgCounter % 2 == 0)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgSchedule setImage:[UIImage imageNamed:@"tab_schedule"]];
            [imgDose setImage:[UIImage imageNamed:@"tab_dose_active"]];
        }
        else
        {
            [imgSchedule setImage:[UIImage imageNamed:@"bm_tab_schedule"]];
            [imgDose setImage:[UIImage imageNamed:@"bm_tab_dose_active"]];
        }
        
        [tblSchedule setAlpha:0];
        
        [self getChildVaccineCard];
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgSchedule setImage:[UIImage imageNamed:@"tab_schedule_active"]];
            [imgDose setImage:[UIImage imageNamed:@"tab_dose"]];
        }
        else
        {
            [imgSchedule setImage:[UIImage imageNamed:@"bm_tab_schedule_active"]];
            [imgDose setImage:[UIImage imageNamed:@"bm_tab_dose"]];
        }
        
        [tblSchedule setAlpha:1];
        [tblDose setAlpha:0];
        [btnUpdate setAlpha:0];
        [btnSubmit setAlpha:0];
        showDefault = 0;
    }
    
    imgCounter++;
}

-(void) getChildVaccineCard
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getChildVaccineCard *request = [[getChildVaccineCard alloc] init_getChildVaccineCard:child.childId vaccineId:vaccine.vaccineId];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getChildVaccineCard"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                doseArr = [[NSMutableArray alloc] init];
                doseTakenArr = [[NSMutableArray alloc] init];
                
                NSArray *tempArr = [responseMessage objectForKey:@"data"];
                
                if([tempArr count] > 0)
                {
                    /* Add fake dose if and only if vaccine id are following : */
                    
                    if([vaccine.vaccineId isEqualToString:@"10"] || [vaccine.vaccineId isEqualToString:@"11"] || [vaccine.vaccineId isEqualToString:@"12"]
                       || [vaccine.vaccineId isEqualToString:@"13"] || [vaccine.vaccineId isEqualToString:@"14"] || [vaccine.vaccineId isEqualToString:@"15"])
                    {
                        /* add another fake dose (header cell description) into dose arr */
                        
                        bizChildVaccineCard *childVaccineCard = [[bizChildVaccineCard alloc] init];
                        [childVaccineCard setVaccineCardId:@"0"];
                        [childVaccineCard setFkVaccineId:@"0"];
                        [childVaccineCard setFkChildId:@"0"];
                        [childVaccineCard setDoseNo:@"0"];
                        [childVaccineCard setStatus:@"100000"];
                        
                        [doseTakenArr addObject:@"100000"];
                        [doseArr addObject:childVaccineCard];
                        
                        /* end of adding */
                    }
                    
                    /* end of adding fake dose */
                }
                
                for(int i = 0; i < tempArr.count; i++)
                {
                    bizChildVaccineCard *childVaccineCard = [[bizChildVaccineCard alloc] init];
                    [childVaccineCard setVaccineCardId:[[tempArr objectAtIndex:i] objectForKey:@"vaccineCard_id"]];
                    [childVaccineCard setFkVaccineId:[[tempArr objectAtIndex:i] objectForKey:@"vaccine_id"]];
                    [childVaccineCard setFkChildId:[[tempArr objectAtIndex:i] objectForKey:@"child_id"]];
                    [childVaccineCard setDoseNo:[[tempArr objectAtIndex:i] objectForKey:@"dose_no"]];
                    [childVaccineCard setStatus:[[tempArr objectAtIndex:i] objectForKey:@"status"]];
                    
                    [doseTakenArr addObject:[[tempArr objectAtIndex:i] objectForKey:@"status"]];
                    [doseArr addObject:childVaccineCard];
                }
            }
            
            showDefault = 1;
            [tblDose reloadData];
            [tblDose setAlpha:1];
            [btnUpdate setAlpha:1];
            
            [SVProgressHUD dismiss];
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"updateVaccineCard"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Update success")
                                 message:LocalizedString(@"Thank you, Mummy. You can also update this record card yourself within the app") delegate:nil
                                       cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
                
                // refresh the view
                
                [self getChildVaccineCard];
            }
        }
    }
    
    // [SVProgressHUD dismiss];
}

-(NSString*) getDoseName_en :(NSString*) doseId
{
    NSString *doseName = @"";
    
    if([doseId isEqualToString:@"1"])
    {
        doseName = @"1st Dose";
    }
    else if([doseId isEqualToString:@"2"])
    {
        doseName = @"2nd Dose";
    }
    else if([doseId isEqualToString:@"3"])
    {
        doseName = @"3rd Dose";
    }
    else if([doseId isEqualToString:@"4"])
    {
        doseName = @"4th Dose";
    }
    else if([doseId isEqualToString:@"booster"])
    {
        doseName = @"Booster";
    }
    else if([doseId isEqualToString:@"booster2"])
    {
        doseName = @"Booster 2";
    }
    else if([doseId isEqualToString:@"booster3"])
    {
        doseName = @"Booster 3";
    }
    
    return doseName;
}

-(NSString*) getDoseName_ms :(NSString*) doseId
{
    NSString *doseName = @"";
    
    if([doseId isEqualToString:@"1"])
    {
        doseName = @"Dos 1";
    }
    else if([doseId isEqualToString:@"2"])
    {
        doseName = @"Dos 2";
    }
    else if([doseId isEqualToString:@"3"])
    {
        doseName = @"Dos 3";
    }
    else if([doseId isEqualToString:@"4"])
    {
        doseName = @"Dos 4";
    }
    else if([doseId isEqualToString:@"booster"])
    {
        doseName = @"Booster";
    }
    else if([doseId isEqualToString:@"booster2"])
    {
        doseName = @"Booster 2";
    }
    else if([doseId isEqualToString:@"booster3"])
    {
        doseName = @"Booster 3";
    }
    
    return doseName;
}

- (IBAction)update:(id)sender {
    
    showDefault = 0;
    
    [tblDose reloadData];
    
    [btnUpdate setAlpha:0];
    [btnSubmit setAlpha:1];
}

- (IBAction)submit:(id)sender {
    
    // validation
    
    bool invalidFlag = NO;
    
    /* Note : Dose status need to be updated 1 by 1 */
    
    for(int i = 0; i < doseTakenArr.count; i++)
    {
        /* dont care fake dose */
        
        if(i == 0 && [[doseTakenArr objectAtIndex:i] intValue] == 100000){     continue;   }
        
        /* end of dont care */
        
        if(invalidFlag)
        {
            // check if value other than 0
            
            if([[doseTakenArr objectAtIndex:i] intValue] != 0)
            {
                [self showErrorMsg:i];
                
                return;
            }
        }
        
        if([[doseTakenArr objectAtIndex:i] intValue] != 1)
        {
            invalidFlag = YES;
        }
    }
    
    // if all is 0, prompt a message urging the user to set at least 1 status
    
    int doseIsNotZero = 0;
    
    for(int i = 0; i < doseTakenArr.count; i++)
    {
        /* dont care fake dose */
        
        if(i == 0 && [[doseTakenArr objectAtIndex:i] intValue] == 100000){     continue;   }
        
        /* end of dont care */
        
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

-(void) showErrorMsg :(int) index
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    // dismiss old code
    /*NSString *previousDose = @"";
    NSString *currentDose = @"";
    
    bizChildVaccineCard *preVaccinationCard = [doseArr objectAtIndex:index-1];
    bizChildVaccineCard *curVaccinationCard = [doseArr objectAtIndex:index];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        previousDose = [self getDoseName_en:preVaccinationCard.doseNo];
        currentDose = [self getDoseName_en:curVaccinationCard.doseNo];
    }
    else
    {
        previousDose = [self getDoseName_ms:preVaccinationCard.doseNo];
        currentDose = [self getDoseName_ms:curVaccinationCard.doseNo];
    }
    
    NSString *str1 = LocalizedString(@"Please update");
    NSString *str2 = LocalizedString(@"(& any previous dose) to YES before you update");
    NSString *str3 = LocalizedString(@"and so on");
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Important")
                message:[NSString stringWithFormat:@"%@ %@ %@ %@ %@.", str1, previousDose, str2, currentDose, str3] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];*/
    
    NSString *str1 = LocalizedString(@"Your child needs to have received the previous dose before getting this one.");
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Ooops!")
                                                      message:str1 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
}

-(void) updateDoseStatus
{
    NSMutableArray *listOfDose = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < doseArr.count; i++)
    {
        /* dont care fake dose */
        
        if(i == 0 && [[doseTakenArr objectAtIndex:i] intValue] == 100000){     continue;   }
        
        /* end of dont care */
        
        bizChildVaccineCard *childVaccineCard = [doseArr objectAtIndex:i];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:[NSString stringWithFormat:@"%@", childVaccineCard.doseNo] forKey:@"doseNo"];
        [dic setObject:[NSString stringWithFormat:@"%@", [doseTakenArr objectAtIndex:i]] forKey:@"doseStatus"];
        
        [listOfDose addObject:dic];
    }

    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    updateVaccineCard *request = [[updateVaccineCard alloc] init_updateVaccineCard:child.childId vaccineId:vaccine.vaccineId vaccineDoseList:listOfDose];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

@end
