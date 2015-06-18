//
//  getChilds.m
//  myVac4Baby
//
//  Created by Jun on 14/11/2.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "getChilds.h"

@implementation getChilds

-(id)init_getChilds :(NSString*) momId
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getChildByMomId";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getChildByMomId"
         POST['data'] = { "getChildByMomId_data": { "momId":"1" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:momId forKey:@"momId"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getChildByMomId_data"];
    }
    
    return self;
}

@end
