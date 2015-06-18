//
//  signUpNewsLetter.m
//  myVac4Baby
//
//  Created by Jun on 14/10/31.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "signUpNewsLetter.h"

@implementation signUpNewsLetter

-(id)init_signUp :(NSString*) email iname:(NSString*)name imobileno:(NSString*)mobileno
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"signUpNewsLetter";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "signUpNewsLetter"
         POST['data'] = { "signUpNewsLetter_data": { "name":"zen", "email":"ok@gmail.com", "mobileNo":"012-0000000" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:email forKey:@"name"];
        [jsonDictcol setValue:name forKey:@"email"];
        [jsonDictcol setValue:mobileno forKey:@"mobileNo"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"signUpNewsLetter_data"];
    }
    
    return self;
}

@end
