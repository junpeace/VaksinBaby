//
//  getChildVaccineCard.m
//  myVac4Baby
//
//  Created by jun on 11/12/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "getChildVaccineCard.h"

@implementation getChildVaccineCard

-(id)init_getChildVaccineCard :(NSString*) ichildId vaccineId:(NSString*) ivaccineId
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getChildVaccineCard";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getChildVaccineCard"
         POST['data'] = { "getChildVaccineCard_data": { "childId":"1", "vaccineId":"1" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:ichildId forKey:@"childId"];
        [jsonDictcol setValue:ivaccineId forKey:@"vaccineId"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getChildVaccineCard_data"];
    }
    
    return self;
}

@end
