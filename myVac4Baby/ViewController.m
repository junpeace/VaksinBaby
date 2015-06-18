//
//  ViewController.m
//  myVac4Baby
//
//  Created by jun on 10/28/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performSelector:@selector(proceedView) withObject:nil afterDelay:3];
}

-(void) viewWillAppear:(BOOL)animated
{
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_splashscreen.png"]]];
}

-(void) proceedView
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched - entrySegue
        
        NSLog(@"launch once");
        
        [self performSegueWithIdentifier:@"entrySegue" sender:nil];
    }
    else
    {
        NSLog(@"first launch");
        
        // delete previous account
        NSString *password = [SSKeychain passwordForService:@"myVac4Baby" account:@"anyUser"];
        
        if (password != nil)
        {
            [SSKeychain deletePasswordForService:@"myVac4Baby" account:@"anyUser"];
        }
        
        [self performSegueWithIdentifier:@"firstTime" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
