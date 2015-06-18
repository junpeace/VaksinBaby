//
//  getVaccineByIds.m
//  myVac4Baby
//
//  Created by Jun on 14/11/16.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "getVaccineByIds.h"

@implementation getVaccineByIds

-(id)init_getVaccineByIds :(NSString*) language strIds :(NSString*)istrIds
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getVaccinesByIds";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getVaccinesByIds"
         POST['data'] = { "getVaccinesByIds_data": { "language":"en/bm", "vaccineIds":"1,2,3" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:language forKey:@"language"];
        [jsonDictcol setValue:istrIds forKey:@"vaccineIds"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getVaccinesByIds_data"];
    }
    
    return self;
}

@end
