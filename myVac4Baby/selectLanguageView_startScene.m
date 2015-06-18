//
//  selectLanguageView_startScene.m
//  myVac4Baby
//
//  Created by jun on 11/7/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "selectLanguageView_startScene.h"

@interface selectLanguageView_startScene ()

@end

@implementation selectLanguageView_startScene

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)english:(id)sender {
    
    // set child object
    [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"languagePreference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"startSceneTutorialSegue" sender:nil];
}

- (IBAction)bahasaMelayu:(id)sender {
    
    // set child object
    [[NSUserDefaults standardUserDefaults] setObject:@"ms" forKey:@"languagePreference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"startSceneTutorialSegue" sender:nil];
}

@end
