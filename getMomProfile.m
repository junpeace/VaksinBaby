//
//  getMomProfile.m
//  myVac4Baby
//
//  Created by jun on 11/10/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "getMomProfile.h"

@implementation getMomProfile

-(id)init_getMomProfile :(NSString*) momId
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getMomProfile";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getMomProfile"
         POST['data'] = { "getMomProfile_data": { "momId":"1" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:momId forKey:@"momId"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getMomProfile_data"];
    }
    
    return self;
}

@end
