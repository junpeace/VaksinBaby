//
//  updateVaccineCard.m
//  myVac4Baby
//
//  Created by jun on 11/12/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "updateVaccineCard.h"

@implementation updateVaccineCard

-(id)init_updateVaccineCard :(NSString*) ichildId vaccineId:(NSString*) ivaccineId vaccineDoseList:(NSArray*)ivaccineDoseList
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"updateVaccineCard";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "updateVaccineCard"
         POST['data'] = { "updateVaccineCard_data": { "childId":"1", "vaccineId":"1", "vaccineDoseList":[{"doseNo":"1", "doseStatus":"0"}, {"doseNo":"2", "doseStatus":"1"}] } }

         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:ichildId forKey:@"childId"];
        [jsonDictcol setValue:ivaccineId forKey:@"vaccineId"];
        [jsonDictcol setValue:ivaccineDoseList forKey:@"vaccineDoseList"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"updateVaccineCard_data"];
    
        // NSLog(@"self json dict : %@", self.jsonDicttbl);
    }
    
    return self;
}

@end
