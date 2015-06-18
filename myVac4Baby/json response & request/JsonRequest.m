//
//  CRequest.m
//  couper
//
//  Created by Tiseno Mac 2 on 5/30/13.
//  Copyright (c) 2013 Tiseno Mac 2. All rights reserved.
//

#import "JsonRequest.h"

@implementation JsonRequest

-(id)init
{
    self = [super init];
    
    if(self)
    {
        // dbIPServer *db = [[dbIPServer alloc] init];
        // NSMutableArray *IPArr = [db selectIP_FromnLocalDB];
        // NSDictionary *strIP = [IPArr objectAtIndex:0];
        // self.webserviceURL = [NSString stringWithFormat:@"http://%@/api.php?action=", [strIP objectForKey:@"ServerIP"]];
        // self.webserviceURL = [NSString stringWithFormat:@"http://%@/api.php?action=", [strIP objectForKey:@"ServerIP"]];
        
        // NSLog(@"self.webserviceURL--->%@",self.webserviceURL);
        
        self.webserviceURL = @"http://54.251.175.250/MyVac4Baby/api.php?action=";
    }
    return self;
}

@end
