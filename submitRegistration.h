//
//  submitRegistration.h
//  myVac4Baby
//
//  Created by Jun on 14/11/8.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "JsonRequest.h"
#import "bizRegistration.h"

@interface submitRegistration : JsonRequest

-(id)init_submitRegistration :(bizRegistration*) registration;

@end
