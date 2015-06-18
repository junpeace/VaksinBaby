//
//  getVaccinesForSecondReminder.m
//  VaksinBaby
//
//  Created by jun on 4/14/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "getVaccinesForSecondReminder.h"

@implementation getVaccinesForSecondReminder

-(id)init_getVaccinesForSecondReminder :(NSString*) language strIds :(NSString*)istrIds strMonth:(NSString*) imonth strChildId:(NSString*) ichildId
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getVaccinesForSecondReminder";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getVaccinesForSecondReminder"
         POST['data'] = { "getVaccinesForSecondReminder_data": { "month":"1 Month", "vaccineIds":"2", "language":"en", "childId":"221" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:language forKey:@"language"];
        [jsonDictcol setValue:istrIds forKey:@"vaccineIds"];
        [jsonDictcol setValue:imonth forKey:@"month"];
        [jsonDictcol setValue:ichildId forKey:@"childId"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getVaccinesForSecondReminder_data"];
    }
    
    return self;
}

@end
