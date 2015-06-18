//
//  AppDelegate.m
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize navigateTo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [TestFlight takeOff:@"93dc9264-e1cc-4d44-97cc-c9fea74cb7c8"];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bar_combined.png"] forBarMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
         [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont fontWithName:@"STYuanti-SC-Regular" size:19.0], NSFontAttributeName, nil]];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    // handling local notification when app is closed
    if(launchOptions != nil)
    {
        UILocalNotification *localNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
        
        if (localNotif)
        {
            [[NSUserDefaults standardUserDefaults] setObject:localNotif.userInfo forKey:@"notificationDict"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"receivedReminder"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
        
    [self initKeyBoard];
    
    return YES;
}

-(void) initKeyBoard
{
    // Preloads keyboard so there's no lag on initial keyboard appearance.
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive)
    {
        // check if user logged in
        
        
        // set different language display text
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        {     LocalizationSetLanguage(@"en"); }
        else
        {  LocalizationSetLanguage(@"ms"); }
        
        if([[notification.userInfo objectForKey:@"pushNotificationType"] isEqualToString:@"1"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vaksin Baby"
                                                            message:LocalizedString(notification.alertBody)
                                                           delegate:self cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert addButtonWithTitle:@"Read more"];
            [alert show];
        }
        else if([[notification.userInfo objectForKey:@"pushNotificationType"] isEqualToString:@"2"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vaksin Baby"
                                                            message:LocalizedString(notification.alertBody)
                                                           delegate:self cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert addButtonWithTitle:@"Update"];
            [alert show];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:notification.userInfo forKey:@"notificationDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"receivedReminder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    id presentedViewController = [window.rootViewController presentedViewController];
    NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
    
    if (window && [className isEqualToString:@"AVFullScreenViewController"])
    {        
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if([navigateTo isEqualToString:@"otherResources"])
        {
            /* other resources */
                        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"otherResourcesView_receiveNotification_" object:self];
        }
        else if([navigateTo isEqualToString:@"signUpNewsLetter"])
        {
            /* sign up news letter */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"signUpNewsLetterView_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"takeTour"])
        {
            /* take a tour */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"takeTourView_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"selectLanguage"])
        {
            /* select language */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLanguage_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"vaccinePreventableDisease"])
        {
            /* vaccine preventable disease */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vaccinePreventableDisease_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"vaccinePreventableDiseaseWebView"])
        {
            /* vaccine preventable disease detail web view */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vaccinePreventableDiseaseWebView_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"video"])
        {
            /* video */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"video_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"videoDetail"])
        {
            /* video detail */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"videoDetail_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"reportAdversedEffect"])
        {
            /* report adversed effect */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reportAdversedEffect_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"reportAdversedEffectVaccines"])
        {
            /* report adversed effect vaccines */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reportAdversedEffectVaccines_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"userProfile"])
        {
            /* user profile */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfile_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"childProfile"])
        {
            /* child profile */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"childProfile_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"vaccinationTracker"])
        {
            /* vaccination tracker */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vaccinationTracker_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"vaccinationTrackerVaccinesList"])
        {
            /* vaccination tracker vaccines list */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vaccinationTrackerVaccinesList_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"createChild"])
        {
            /* create child */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createChild_receivseNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"createChild2"])
        {
            /* create child detail */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createChild2_receivseNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"mainMenu"])
        {
            /* main menu */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mainMenu_receivseNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"autoReminder"])
        {
            /* auto reminder */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"autoReminder_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"childProfileLeftMenu"])
        {
            /* child profile left menu */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"childProfileLeftMenu_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"createChildLeftMenu"])
        {
            /* create child left menu */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createChildLeftMenu_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"createChildLeftMenu2"])
        {
            /* create child left menu detail */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createChildLeftMenu2_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"forgetPassword"])
        {
            /* forget password */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"forgetPassword_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"registration"])
        {
            /* registration */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registration_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"registrationGender"])
        {
            /* registration gender */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registrationGender_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"registrationEmployer"])
        {
            /* registration employer */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registrationEmployer_receiveNotification" object:self];
        }
        else if([navigateTo isEqualToString:@"registrationHealthcare"])
        {
            /* registration healthcare */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registrationHealthcare_receiveNotification" object:self];
        }
    }
    else
    { /* clicked on cancel */ }
}

@end
