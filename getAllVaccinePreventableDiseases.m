//
//  getAllVaccinePreventableDiseases.m
//  myVac4Baby
//
//  Created by jun on 10/31/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "getAllVaccinePreventableDiseases.h"

@implementation getAllVaccinePreventableDiseases

-(id)init_getAllVaccinePreventableDiseases :(NSString*) language
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getVaccinePreventableDisease";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getVaccinePreventableDisease"
         POST['data'] = { "getVaccinePreventableDisease_data": { "language":"en/bm" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:language forKey:@"language"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getVaccinePreventableDisease_data"];
    }
    
    return self;
}

@end
