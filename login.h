//
//  login.h
//  myVac4Baby
//
//  Created by jun on 11/14/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface login : JsonRequest

-(id)init_login :(NSString*) username ipassword:(NSString*)password;

@end
