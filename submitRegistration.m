//
//  submitRegistration.m
//  myVac4Baby
//
//  Created by Jun on 14/11/8.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "submitRegistration.h"

@implementation submitRegistration

-(id)init_submitRegistration :(bizRegistration*) registration
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"registration";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "registration"
         POST['data'] = { "registration_data": { "firstName":"samantha", "lastName":"Frisby", "gender":"Female", "dateOfBirth":"2019-10-09", "email":"frisby@gmail.com", "mobile":"012-0923341", "postcode":"21000", "employer":"Government/Private/Own Business/Not employed", "healthcarePreference":"Goverment/Private", "userName":"samantha", "password":"1234" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:registration.name forKey:@"firstName"];
        [jsonDictcol setValue:registration.name forKey:@"lastName"];
        [jsonDictcol setValue:registration.gender forKey:@"gender"];
        [jsonDictcol setValue:registration.dob forKey:@"dateOfBirth"];
        [jsonDictcol setValue:registration.email forKey:@"email"];
        [jsonDictcol setValue:registration.mobile forKey:@"mobile"];
        [jsonDictcol setValue:registration.postcode forKey:@"postcode"];
        [jsonDictcol setValue:registration.employer forKey:@"employer"];
        [jsonDictcol setValue:registration.hp forKey:@"healthcarePreference"];
        [jsonDictcol setValue:registration.username forKey:@"userName"];
        [jsonDictcol setValue:registration.password forKey:@"password"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"registration_data"];
    }
    
    return self;
}

@end
