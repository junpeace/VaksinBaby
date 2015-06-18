//
//  updateVaccineCardSecondReminders.m
//  VaksinBaby
//
//  Created by jun on 4/15/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "updateVaccineCardSecondReminders.h"

@implementation updateVaccineCardSecondReminders

-(id)init_updateVaccineCardSecondReminders :(NSString*) ichildId vaccineDoseList:(NSArray*)ivaccineDoseList
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"updateVaccineCardSecondReminder";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "updateVaccineCardSecondReminder"
         POST['data'] = { "updateVaccineCardSecondReminder_data": { "childId":"1", "vaccineId":"1", "vaccineDoseList":[{"doseNo":"1", "doseStatus":"0"}, {"doseNo":"2", "doseStatus":"1"}] } }
         
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:ichildId forKey:@"childId"];
        [jsonDictcol setValue:ivaccineDoseList forKey:@"vaccineDoseList"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"updateVaccineCardSecondReminder_data"];
        
        // NSLog(@"self json dict : %@", self.jsonDicttbl);
    }
    
    return self;
}

@end
