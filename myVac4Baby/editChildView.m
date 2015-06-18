//
//  editChildView.m
//  myVac4Baby
//
//  Created by jun on 11/5/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "editChildView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)

+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    
    if(data == nil){return nil;}
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end

@interface editChildView ()

@end

@implementation editChildView

@synthesize child;
@synthesize txtChildName;
@synthesize imgGirl, imgBoy;
@synthesize txtDate, btnSave;
@synthesize imgBaby;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    editLock = 0;
    
    [self performSelector:@selector(setUpView) withObject:nil afterDelay:1];
    
    notificationArr = [[NSMutableArray alloc] init];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"childProfile_receiveNotification"])
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
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    NSString *s = LocalizedString(@"profile");
    
    NSString *str = [NSString stringWithFormat:@"%@'s %@", child.childName, s];
    
    [btnSave setTitle:LocalizedString(@"Save") forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = str;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"childProfile";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"childProfile_receiveNotification"
                                               object:nil];
}

-(void)dismissKeyboard {
    
    [txtChildName resignFirstResponder];
    [txtDate resignFirstResponder];
    
    if(counter % 2 != 0)
    {
        [self moveScreenDown];
    }
    
    counter = 0;
}

-(void) setUpView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
    
    UIImage *img1=[UIImage imageNamed:@"btn_edit"];
    
    CGRect frameimg1 = CGRectMake(0, 0, img1.size.width, img1.size.height);
    
    UIButton *signOut = [[UIButton alloc]initWithFrame:frameimg1];
    [signOut setBackgroundImage:img1 forState:UIControlStateNormal];
    [signOut addTarget:self action:@selector(beginEdit) forControlEvents:UIControlEventTouchUpInside];
    [signOut setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:signOut];
    self.navigationItem.rightBarButtonItem = barButton;

    [txtChildName setText:child.childName];
    
    [txtChildName setEnabled:NO];
    [txtDate setEnabled:NO];
    
    txtDate.delegate = self;
    
    imgBaby.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert1:)];
    
    tap.numberOfTapsRequired = 1;
    
    imgBaby.layer.cornerRadius = imgBaby.frame.size.height /2;
    imgBaby.layer.masksToBounds = YES;
    imgBaby.layer.borderWidth = 1.0f;
    imgBaby.layer.borderColor = [UIColor whiteColor].CGColor;
    imgBaby.clipsToBounds = YES;
    imgBaby.contentMode = UIViewContentModeScaleAspectFit;
    
    [imgBaby addGestureRecognizer:tap];
    [imgBaby setImageWithURL:[NSURL URLWithString:child.childImageUrl] placeholderImage:[UIImage imageNamed:@"default_addaphotoofyourbaby"]];
    
    [txtDate setText:[self formatDate:child.childDateOfBirth]];
    
    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 320, 216)];
    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_SG"];
    
    [pickerView addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    // set datepicker date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSDate *currentDate = [dateFormatter dateFromString:child.childDateOfBirth];
    
    [pickerView setDate:currentDate];
    
    [txtDate setInputView:pickerView];
    
    [self setGenderImg:child.childGender];
    
    strDOB = child.childDateOfBirth;
    
    [SVProgressHUD dismiss];
}

-(void) setGenderImg :(NSString*) gender
{
    if( [gender caseInsensitiveCompare:@"male"] == NSOrderedSame )
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgBoy setImage:[UIImage imageNamed:@"tab_boy_active"]];
            [imgGirl setImage:[UIImage imageNamed:@"tab_girl"]];
        }
        else
        {
            [imgBoy setImage:[UIImage imageNamed:@"bm_tab_boy_active"]];
            [imgGirl setImage:[UIImage imageNamed:@"bm_tab_girl"]];
        }
        
        strGender = @"Male";
        imgCounter = 1;
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgBoy setImage:[UIImage imageNamed:@"tab_boy"]];
            [imgGirl setImage:[UIImage imageNamed:@"tab_girl_active"]];
        }
        else
        {
            [imgBoy setImage:[UIImage imageNamed:@"bm_tab_boy"]];
            [imgGirl setImage:[UIImage imageNamed:@"bm_tab_girl_active"]];
        }
        
        strGender = @"Female";
        imgCounter = 0;
    }
}

-(NSString*) formatDate:(NSString*) childDateOfBirth
{
    NSArray *stringArray = [childDateOfBirth componentsSeparatedByString: @"-"];
    NSString *monthName = @"";
    
    if([stringArray count] == 3)
    {
        switch ([[stringArray objectAtIndex:1] intValue]) {
            case 1:
                monthName = @"January";
                break;
            case 2:
                monthName = @"February";
                break;
            case 3:
                monthName = @"March";
                break;
            case 4:
                monthName = @"April";
                break;
            case 5:
                monthName = @"May";
                break;
            case 6:
                monthName = @"June";
                break;
            case 7:
                monthName = @"July";
                break;
            case 8:
                monthName = @"August";
                break;
            case 9:
                monthName = @"September";
                break;
            case 10:
                monthName = @"October";
                break;
            case 11:
                monthName = @"November";
                break;
            case 12:
                monthName = @"December";
                break;
                
            default:
                break;
        }
        
        return [NSString stringWithFormat:@"%@ %@ %@", [stringArray objectAtIndex:2], monthName, [stringArray objectAtIndex:0]];
    }
    
    return @"";
}

-(void)updateTextField:(id)sender
{
    // show date
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd LLLL yyyy"];
    
    NSLocale* formatterLocale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter2 setLocale:formatterLocale2];
    
    NSString *showDate = [dateFormatter2 stringFromDate:[pickerView date]];
    
    [txtDate setText:showDate];
    
    // get selected date in the correct format
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSString *currentDate = [dateFormatter stringFromDate:[pickerView date]];
    
    strDOB = [currentDate substringToIndex:10];
}

- (void)showAlert1:(UITapGestureRecognizer *)sender
{
    if(editLock == 0){ return; }
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LocalizedString(@"Choose an option")
                                                             delegate:self
                                                    cancelButtonTitle:LocalizedString(@"Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:LocalizedString(@"Take photo"), LocalizedString(@"Choose photo"), nil];*/
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [actionSheet addButtonWithTitle:LocalizedString(@"Take Photo")];
    [actionSheet addButtonWithTitle:LocalizedString(@"Choose photo")];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:LocalizedString(@"Cancel")];
    actionSheet.delegate = self;
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"] || [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Batal"])
    {
        return;
    }
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"STYuanti-SC-Regular" size:19.0] } forState:UIControlStateNormal];
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.navigationBar.tintColor = [UIColor whiteColor];
    cameraUI.allowsEditing = YES;
    
    if(buttonIndex == 0)
    {
        /* camera */
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if(buttonIndex == 1)
    {
        /* album */
        
        // if set source type to UIImagePickerControllerSourceTypeSavedPhotosAlbum (moment)
        // cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    cameraUI.delegate = (id)self;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self presentViewController:cameraUI animated:YES completion:nil];
        }];
        
    }
    else{
        
        [self presentViewController:cameraUI animated:YES completion:nil];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    // NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    imgBaby.layer.cornerRadius = imgBaby.frame.size.height / 2;
    imgBaby.layer.masksToBounds = YES;
    imgBaby.layer.borderWidth = 0;
    imgBaby.clipsToBounds = YES;
    imgBaby.layer.borderWidth = 1.0f;
    imgBaby.layer.borderColor = [UIColor whiteColor].CGColor;
    imgBaby.contentMode = UIViewContentModeScaleAspectFit;

    imgBaby.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imgBaby.layer.cornerRadius = imgBaby.frame.size.height /2;
    imgBaby.layer.masksToBounds = YES;
    imgBaby.layer.borderWidth = 0;
    
    imgBaby.image =  info[UIImagePickerControllerOriginalImage];
        
    [picker dismissViewControllerAnimated:YES completion:nil];
}
*/

-(void) beginEdit
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc];
    
    editLock = 1;
    
    [btnSave setAlpha:1];
    [txtChildName setEnabled:YES];
    [txtDate setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        bizChild *child_ = [[bizChild alloc] init];
        [child_ setChildId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childId"]];
        [child_ setChildImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDict"] objectForKey:@"childImgUrl"]];
        
        notificationView *SegueController = (notificationView*)[segue destinationViewController];
        SegueController.child_passBy = child_;
    }
}

- (IBAction)changeImg:(id)sender {
    
    if(editLock ==0){ return;}
    
    if(imgCounter % 2 == 0)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgBoy setImage:[UIImage imageNamed:@"tab_boy_active"]];
            [imgGirl setImage:[UIImage imageNamed:@"tab_girl"]];
        }
        else
        {
            [imgBoy setImage:[UIImage imageNamed:@"bm_tab_boy_active"]];
            [imgGirl setImage:[UIImage imageNamed:@"bm_tab_girl"]];
        }
        
        strGender = @"Male";
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {
            [imgBoy setImage:[UIImage imageNamed:@"tab_boy"]];
            [imgGirl setImage:[UIImage imageNamed:@"tab_girl_active"]];
        }
        else
        {
            [imgBoy setImage:[UIImage imageNamed:@"bm_tab_boy"]];
            [imgGirl setImage:[UIImage imageNamed:@"bm_tab_girl_active"]];
        }
        
        strGender = @"Female";
    }
    
    imgCounter++;
}

- (IBAction)saveInfo:(id)sender {
    
    [self dismissKeyboard];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    // validation
    
    if([txtChildName.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in required (*) fields.") :LocalizedString(@"Incomplete Registration")];
        
        /* set placeholder in color */
        
        NSString *str = LocalizedString(@"Name* (less than 50 characters)");
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range = [str rangeOfString:@"*"];
        
        if (range.location != NSNotFound)
        {       [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, 1)];    }
        
        txtChildName.attributedPlaceholder = string;
        
        /* end of setting */
        
        if([txtDate.text length] == 0)
        {
            /* set txtDob placeholder in color */
            
            str = LocalizedString(@"D.O.B* (due or actual)");
            string = [[NSMutableAttributedString alloc] initWithString:str];
            range = [str rangeOfString:@"*"];
            
            if (range.location != NSNotFound)
            {       [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, 1)];    }
            
            txtDate.attributedPlaceholder = string;
            
            /* end of setting */
        }
        
        return;
    }
    
    if([txtChildName.text length] > 50)
    {
        [self showMessage:LocalizedString(@"Oops! Your child's name cannot be more than 50 characters") :@"Error"];
        
        return;
    }
    
    if([txtDate.text length] == 0)
    {
        [self showMessage:LocalizedString(@"Please fill in required (*) fields.") :LocalizedString(@"Incomplete Registration")];
        
        /* set placeholder in color */
        
        NSString *str = LocalizedString(@"D.O.B* (due or actual)");
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range = [str rangeOfString:@"*"];
        
        if (range.location != NSNotFound)
        {       [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, 1)];    }
        
        txtDate.attributedPlaceholder = string;
        
        /* end of setting */
        
        return;
    }
    
    /*
     GET['action'] = "editChildProfile"
     POST['data'] = { "editChildProfile_data": { "childId":"1", "name":"nata", "gender":"female", "dateOfBirth":"2014-09-21", "momId":"1" } }
     */
    
    NSMutableDictionary *parentDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:child.childId forKey:@"childId"];
    [dict setValue:txtChildName.text forKey:@"name"];
    [dict setValue:strGender forKey:@"gender"];
    [dict setValue:strDOB forKey:@"dateOfBirth"];
    [dict setValue:[SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"] forKey:@"momId"];
    
    [parentDict setValue:dict forKey:@"editChildProfile_data"];
    
    [self CallService:parentDict forimage:UIImageJPEGRepresentation(imgBaby.image, 1) atAction:@"editChildProfile"];
}

-(void) showMessage :(NSString*)msg :(NSString*) title
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(title)
                                                      message:msg delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
    
    [SVProgressHUD dismiss];
}

-(void)CallService:(NSMutableDictionary *)data forimage:(NSData*)imageData atAction:(NSString *)action {
    
    JsonRequest *ws = [[JsonRequest alloc] init];
    
    //Making Url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ws.webserviceURL, action]];
    
    //making request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *stringBoundary = @"0xKhTisenomLbOuNdArY";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
    
    // Convert dictionry to NSData
    NSData * jsondata = [data toJSON];
    NSString *jsonString = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    NSMutableData *postBody = [NSMutableData data];;
    [postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"data\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    if(imageData != nil)
    {
        // append image data
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"babyImage\"; filename=\"%@\"\r\n", @"image.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:imageData];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    [request setHTTPBody:postBody];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"response length=%lld  statecode%d", [response expectedContentLength],responseCode);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"fail");
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Update failed")
                                                      message:LocalizedString(@"Oops! Sorry Mummy. Please check your internet connection.") delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
    
    [SVProgressHUD dismiss];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if([[json objectForKey:@"action"] isEqualToString:@"editChildProfile"])
    {
        if([[json objectForKey:@"result"] intValue] == 1)
        {
            // if child's birthday has been changed
            if(![child.childDateOfBirth isEqualToString:strDOB])
            {
                [self removePreviousReminder:child.childId];
                
                // re-create 1st reminder
                [self createFirstNotifications:child.childId ichildImageUrl:[json objectForKey:@"childImageUrl"]];
                
                // re-create 2nd reminder
                [self createSecondNotifications:child.childId ichildImageUrl:[json objectForKey:@"childImageUrl"]];
                
                // delete all previous notifications
                // only then insert new notifications
                latestNotification *dbNotification = [[latestNotification alloc] init];
                [dbNotification deleteNotificationsByChildId:child.childId];
                [dbNotification insertLatestNotificationsInOneTime:notificationArr];
            }
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Thank You")
                                                              message:LocalizedString(@"Your child's profile has been successfully updated.") delegate:nil
                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [message show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        NSLog(@"childRegistration : error : %@", json);
    }
    
    [SVProgressHUD dismiss];
}

-(void) removePreviousReminder :(NSString*) childId
{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *localNotification in arrayOfLocalNotifications)
    {
        if([[localNotification.userInfo objectForKey:@"childId"] intValue] == [childId intValue])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
        }
    }
}

#pragma mark UITextField

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveScreenUp:textField];
}

-(void) moveScreenUp: (UITextField *)textField
{
    counter = 1;
    
    CGRect textFieldRect = [self.view convertRect:textField.bounds fromView:textField];
    
    CGRect viewRect = [self.view convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        // ipad
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
        if(animatedDistance < 150)
        {
            // ipod touch
            animatedDistance = animatedDistance / 3;
        }
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    animatedDistance = animatedDistance - 60;
    
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void) moveScreenDown
{
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


-(void) createFirstNotifications :(NSString*) childId ichildImageUrl:(NSString*)childImageUrl
{
    // get all first notifications details
    firstNotification *notification = [[firstNotification alloc] init];
    NSArray *allFirstNotifications;
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        LocalizationSetLanguage(@"en");
        allFirstNotifications = [notification retrieveAllFirstNotifications];
    }
    else
    {
        LocalizationSetLanguage(@"ms");
        allFirstNotifications = [notification retrieveAllFirstNotifications_ms];
    }
    
    // date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSDateComponents *dateComponents;
    
    // child's birthday
    // NSString *currentDate = @"2014-11-29 13:10:00";
    NSString *currentDate = [NSString stringWithFormat:@"%@ 08:00:00", strDOB];
    NSDate *dt = [dateFormatter dateFromString:currentDate];
    
    int addDaysCount = 0;
    NSDate *dummyDate;
    
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [dateformate stringFromDate:[NSDate date]];
    NSString *localNotificationFireDate;
    
    NSString *pre_msg = LocalizedString(@"Vaccination Reminder for");
    NSString *msg = [NSString stringWithFormat:@"%@ %@", pre_msg, txtChildName.text];
    
    NSLog(@"baby bday : %@", dt);
    
    // create 10 2nd notifications
    
    for (int i = 0; i < allFirstNotifications.count; i++)
    {
        // bizFirstNotification *biz = [allFirstNotifications objectAtIndex:i];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setValue:childId forKey:@"childId"];
        [dict setValue:[NSString stringWithFormat:@"%d", i+1] forKey:@"pushNotificationId"];
        [dict setValue:childImageUrl forKey:@"childImgUrl"];
        [dict setValue:@"1" forKey:@"pushNotificationType"];
        
        // NSLog(@"dict : %@", dict);
        
        // calculate notification fire date
        
        switch (i) {
            case 0:
                
                // at birth - add 1 week
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 7;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at birth");
                
                NSLog(@"at birth : %@", dummyDate);
                
                break;
            case 1:
                
                // 1 month - add 1 month
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:1];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 1 month");
                
                NSLog(@"1 month : %@", dummyDate);
                
                break;
            case 2:
                
                // 2 months - add 2 months
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:2];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 2 months");
                
                NSLog(@"2 months : %@", dummyDate);
                
                break;
            case 3:
                
                // 3 months - add 3 months
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:3];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 3 months");
                
                NSLog(@"3 months : %@", dummyDate);
                
                break;
            case 4:
                
                // 5 months - add 5 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:5];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 5 months");
                
                NSLog(@"5 months : %@", dummyDate);
                
                break;
            case 5:
                
                // 6 months - add 6 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:6];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 6 months");
                
                NSLog(@"6 months : %@", dummyDate);
                
                break;
            case 6:
                
                // 9 months - add 9 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:9];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 9 months");
                
                NSLog(@"9 months : %@", dummyDate);
                
                break;
            case 7:
                
                // 12 months - add 12 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:12];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 12 months");
                
                NSLog(@"12 months : %@", dummyDate);
                
                break;
            case 8:
                
                // 18 months - add 18 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:18];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 18 months");
                
                NSLog(@"18 months : %@", dummyDate);
                
                break;
            case 9:
                
                // 21 months - add 21 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:21];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, don't forget my vaccines at 21 months");
                
                NSLog(@"21 months : %@", dummyDate);
                
                break;
            case 10:
                
                // 24 months - add 24 months
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:24];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                // msg = LocalizedString(@"Mummy, thank you for remembering my vaccinations to date. For my continued protection, I will need the following shots in the coming years");
                
                NSLog(@"24 months : %@", dummyDate);
                
                break;
            default:
                break;
        }
        
        // only scehdule reminder where fire date is > than today date
        localNotificationFireDate = [dateformate stringFromDate:dummyDate];
        
        if([todayDate compare:localNotificationFireDate] == NSOrderedDescending)
        {
            continue;
        }
        
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = dummyDate;
        
        NSLog(@"fire date : %@", localNotification.fireDate);
        
        localNotification.alertBody = [NSString stringWithFormat:@"%@", msg];
        
        localNotification.alertAction = @"VaksinBaby";
        
        localNotification.userInfo = dict;
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        // add dict into notification arr for insertion of data later
        [dict setValue:[dateformate stringFromDate:dummyDate] forKey:@"pushNotificationDate"];
        [notificationArr addObject:dict];
    }
    
    NSLog(@"done");
}

-(void) createSecondNotifications:(NSString*) childId ichildImageUrl:(NSString*)childImageUrl
{
    // date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:formatterLocale];
    
    NSDateComponents *dateComponents;
    
    // child's birthday
    // NSString *currentDate = @"2014-11-29 13:10:00";
    NSString *currentDate = [NSString stringWithFormat:@"%@ 08:00:00", strDOB];
    NSDate *dt = [dateFormatter dateFromString:currentDate];
    
    int addDaysCount = 0;
    NSDate *dummyDate;
    
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [dateformate stringFromDate:[NSDate date]];
    NSString *localNotificationFireDate;
    
    NSString *pre_msg = LocalizedString(@"Please update Vaccination Tracker for");
    NSString *msg = [NSString stringWithFormat:@"%@ %@", pre_msg, txtChildName.text];
    
    NSLog(@"baby bday : %@", dt);
    
    // create 10 2nd notifications
    
    for(int i = 0; i < 10; i++)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setValue:childId forKey:@"childId"];
        [dict setValue:[NSString stringWithFormat:@"%d", i+1] forKey:@"pushNotificationId"];
        [dict setValue:childImageUrl forKey:@"childImgUrl"];
        [dict setValue:@"2" forKey:@"pushNotificationType"];
        
        // NSLog(@"dict : %@", dict);
        
        // calculate notification fire date
        
        switch (i) {
            case 0:
                
                // at birth - add 1 week + 28 days
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 35;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                NSLog(@"at birth : %@", dummyDate);
                
                break;
            case 1:
                
                // 1 month - add 1 month + 28 days
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:1];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"1 month : %@", dummyDate);
                
                break;
            case 2:
                
                // 2 months - add 2 months + 28 days
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:2];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"2 months : %@", dummyDate);
                
                break;
            case 3:
                
                // 3 months - add 3 months + 28 days
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:3];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"3 months : %@", dummyDate);
                
                break;
            case 4:
                
                // 5 months - add 5 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:5];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"5 months : %@", dummyDate);
                
                break;
            case 5:
                
                // 6 months - add 6 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:6];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"6 months : %@", dummyDate);
                
                break;
            case 6:
                
                // 9 months - add 9 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:9];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"9 months : %@", dummyDate);
                
                break;
            case 7:
                
                // 12 months - add 12 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:12];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"12 months : %@", dummyDate);
                
                break;
            case 8:
                
                // 18 months - add 18 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:18];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"18 months : %@", dummyDate);
                
                break;
            case 9:
                
                // 21 months - add 21 months + 28 days
                
                dateComponents  = [[NSDateComponents alloc] init];
                [dateComponents setMonth:21];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dt options:0];
                
                dateComponents  = [[NSDateComponents alloc] init];
                addDaysCount = 28;
                [dateComponents setDay:addDaysCount];
                dummyDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dummyDate options:0];
                
                NSLog(@"21 months : %@", dummyDate);
                
                break;
                
            default:
                break;
        }
        
        // only scehdule reminder where fire date is > than today date
        localNotificationFireDate = [dateformate stringFromDate:dummyDate];
        
        if([todayDate compare:localNotificationFireDate] == NSOrderedDescending)
        {
            continue;
        }
        
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = dummyDate;
        
        NSLog(@"fire date : %@", localNotification.fireDate);
        
        localNotification.alertBody = msg;
        
        localNotification.alertAction = @"VaksinBaby";
        
        localNotification.userInfo = dict;
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        // add dict into notification arr for insertion of data later
        [dict setValue:[dateformate stringFromDate:dummyDate] forKey:@"pushNotificationDate"];
        [notificationArr addObject:dict];
    }
    
    NSLog(@"done");
}

@end
