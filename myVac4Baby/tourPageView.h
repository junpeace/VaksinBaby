//
//  tourPageView.h
//  myVac4Baby
//
//  Created by Jun on 14/11/9.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tourPageView : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIImageView *imgTour;
- (IBAction)startNow:(id)sender;

@end
