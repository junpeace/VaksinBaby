//
//  getAllVaccines.m
//  myVac4Baby
//
//  Created by jun on 11/11/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "getAllVaccines.h"

@implementation getAllVaccines

-(id)init_getAllVaccines :(NSString*) language
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getVaccines";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getVaccines"
         POST['data'] = { "getVaccines_data": { "language":"en/bm" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:language forKey:@"language"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getVaccines_data"];
    }
    
    return self;
}

@end
