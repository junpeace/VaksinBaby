//
//  login.m
//  myVac4Baby
//
//  Created by jun on 11/14/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "login.h"

@implementation login

-(id)init_login :(NSString*) username ipassword:(NSString*)password
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"login";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "login"
         POST['data'] = { "login_data": { "userName":"user1", "password":"1234" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:username forKey:@"userName"];
        [jsonDictcol setValue:password forKey:@"password"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"login_data"];
    }
    
    return self;
}

@end
