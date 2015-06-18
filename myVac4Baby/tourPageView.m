//
//  tourPageView.m
//  myVac4Baby
//
//  Created by Jun on 14/11/9.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "tourPageView.h"

@interface tourPageView ()

@end

@implementation tourPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    if(self.index == 6)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
        { [self.btnSubmit setTitle:@"Get Started !" forState:UIControlStateNormal]; }
        else{ [self.btnSubmit setTitle:@"Mulai Sekarang" forState:UIControlStateNormal]; }
        
        self.btnSubmit.alpha = 1.0;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self changeImg:self.index];
}

-(void) changeImg :(NSInteger)index_
{    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {
        switch (index_) {
            case 0:
                [self.imgTour setImage:[UIImage imageNamed:@"tour_1"]];
                break;
            case 1:
                [self.imgTour setImage:[UIImage imageNamed:@"tour_2"]];
                break;
            case 2:
                [self.imgTour setImage:[UIImage imageNamed:@"tour_3"]];
                break;
            case 3:
                [self.imgTour setImage:[UIImage imageNamed:@"tour_4"]];
                break;
            case 4:
                [self.imgTour setImage:[UIImage imageNamed:@"tour_5"]];
                break;
            case 5:
                [self.imgTour setImage:[UIImage imageNamed:@"tour_6"]];
                break;
            case 6:
                [self.imgTour setImage:[UIImage imageNamed:@"tour_7"]];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (index_) {
            case 0:
                [self.imgTour setImage:[UIImage imageNamed:@"bm_tour_1"]];
                break;
            case 1:
                [self.imgTour setImage:[UIImage imageNamed:@"bm_tour_2"]];
                break;
            case 2:
                [self.imgTour setImage:[UIImage imageNamed:@"bm_tour_3"]];
                break;
            case 3:
                [self.imgTour setImage:[UIImage imageNamed:@"bm_tour_4"]];
                break;
            case 4:
                [self.imgTour setImage:[UIImage imageNamed:@"bm_tour_5"]];
                break;
            case 5:
                [self.imgTour setImage:[UIImage imageNamed:@"bm_tour_6"]];
                break;
            case 6:
                [self.imgTour setImage:[UIImage imageNamed:@"tour_7"]];
                break;
            default:
                break;
        }
    }
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

- (IBAction)startNow:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissTourView" object:self];
}

@end
