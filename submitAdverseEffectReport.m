//
//  submitAdverseEffectReport.m
//  myVac4Baby
//
//  Created by Jun on 14/11/6.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "submitAdverseEffectReport.h"

@implementation submitAdverseEffectReport

-(id)init_submitAdverseEffectReport :(bizAdverseReport*) report
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"reportAdversedEffect";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "reportAdversedEffect"
         POST['data'] = { "reportAdversedEffect_data": { "name":"zen", "email":"ok@gmail.com", "mobile":"012-0000000", "childName":"Alex", "childAge":"2 months old", "vaccineDate":"2014-02-13", "typeOfVaccine":"vaccine 01", "hospital":"Government", "doctorName":"Dr. Villa", "description":"fantastic", "momId":"1" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:report.name forKey:@"name"];
        [jsonDictcol setValue:report.email forKey:@"email"];
        [jsonDictcol setValue:report.mobileNo forKey:@"mobile"];
        [jsonDictcol setValue:report.childName forKey:@"childName"];
        [jsonDictcol setValue:report.childAge forKey:@"childAge"];
        [jsonDictcol setValue:report.vaccineDate forKey:@"vaccineDate"];
        [jsonDictcol setValue:report.typeOfVaccine forKey:@"typeOfVaccine"];
        [jsonDictcol setValue:report.hospital forKey:@"hospital"];
        [jsonDictcol setValue:report.doctName forKey:@"doctorName"];
        [jsonDictcol setValue:report.illDesc forKey:@"description"];
        [jsonDictcol setValue:report.momId forKey:@"momId"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"reportAdversedEffect_data"];
    }
    
    return self;
}

@end
