//
//  getMomNameTelEmail_reportAdverseEffect.m
//  myVac4Baby
//
//  Created by Jun on 15/1/24.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getMomNameTelEmail_reportAdverseEffect.h"

@implementation getMomNameTelEmail_reportAdverseEffect

-(id)init_getMomNameTelEmail_reportAdverseEffect :(NSString*) momId
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getMomNameTelEmail_reportAdverseEffect";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getMomNameTelEmail_reportAdverseEffect"
         POST['data'] = { "getMomNameTelEmail_reportAdverseEffect_data": { "momId":"1" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:momId forKey:@"momId"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getMomNameTelEmail_reportAdverseEffect_data"];
    }
    
    return self;
}

@end
