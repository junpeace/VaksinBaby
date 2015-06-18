//
//  createChildView.m
//  myVac4Baby
//
//  Created by jun on 11/3/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "createChildView.h"

// http://www.appcoda.com/uiactionsheet-uipopovercontroller-tutorial/

@interface createChildView ()

@end

@implementation createChildView

@synthesize imgBaby;
@synthesize btnCreateChild;
@synthesize lblTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.navigateTo = @"createChild";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"createChild_receivseNotification"
                                               object:nil];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"createChild_receivseNotification"])
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

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
}

-(void) setUpView
{
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    [lblTitle setText:LocalizedString(@"Add a photo of your baby")];
    [btnCreateChild setTitle:LocalizedString(@"Next") forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.title = LocalizedString(@"Register");
    
    imgBaby.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert1:)];
    
    tap.numberOfTapsRequired = 1;
                                                                                                   
    [imgBaby addGestureRecognizer:tap];
}
                                                                                                    
- (void)showAlert1:(UITapGestureRecognizer *)sender
{
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

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if(btnCreateChild.alpha == 0)
    {
        imgBaby.layer.cornerRadius = imgBaby.frame.size.height / 2;
        imgBaby.layer.masksToBounds = YES;
        imgBaby.layer.borderWidth = 0;
        imgBaby.clipsToBounds = YES;
        imgBaby.layer.borderWidth = 1.0f;
        imgBaby.layer.borderColor = [UIColor whiteColor].CGColor;
        imgBaby.contentMode = UIViewContentModeScaleAspectFit;
        
        [btnCreateChild setAlpha:1.0];
    }
    
    imgBaby.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"childDetailSegue"])
    {
        childDetailView *SegueController = (childDetailView*)[segue destinationViewController];
        SegueController.imgBaby = imgBaby.image;
        SegueController.strSkipAddChild = [NSString stringWithFormat:@"%d", skipChildPhoto];        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)proceed:(id)sender
{
    /* with photo */
    
    skipChildPhoto = 2;
    
    [self performSegueWithIdentifier:@"childDetailSegue" sender:nil];
}

- (IBAction)skipAddChildPhoto:(id)sender
{
    /* without photo */
    
    skipChildPhoto = 1;
    
    [self performSegueWithIdentifier:@"childDetailSegue" sender:nil];
}

@end
