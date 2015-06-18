//
//  updateMomProfile.m
//  myVac4Baby
//
//  Created by jun on 11/10/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "updateMomProfile.h"

@implementation updateMomProfile

-(id)init_updateMomProfile :(bizEditMomProfile*) momProfile
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"editMomProfile";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "editMomProfile"
         POST['data'] = { "editMomProfile_data": { "momId":"1", "firstName":"ken", "lastName":"Kwan", "gender":"female", "dateOfBirth":"2014-09-21", "email":"kwan@gmail.com", "mobile":"012-09233234", "postcode":"32000", "employer":"Government", "healthcarePreference":"Government", "userName":"fantastic", "password":"12345" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:momProfile.name forKey:@"firstName"];
        [jsonDictcol setValue:momProfile.name forKey:@"lastName"];
        [jsonDictcol setValue:momProfile.gender forKey:@"gender"];
        [jsonDictcol setValue:momProfile.dob forKey:@"dateOfBirth"];
        [jsonDictcol setValue:momProfile.email forKey:@"email"];
        [jsonDictcol setValue:momProfile.mobile forKey:@"mobile"];
        [jsonDictcol setValue:momProfile.postcode forKey:@"postcode"];
        [jsonDictcol setValue:momProfile.employer forKey:@"employer"];
        [jsonDictcol setValue:momProfile.hp forKey:@"healthcarePreference"];
        [jsonDictcol setValue:momProfile.username forKey:@"userName"];
        [jsonDictcol setValue:momProfile.password forKey:@"password"];
        [jsonDictcol setValue:momProfile.momId forKey:@"momId"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"editMomProfile_data"];
    }
    
    return self;
}
@end
