//
//  signUpNewsLetter.h
//  myVac4Baby
//
//  Created by Jun on 14/10/31.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface signUpNewsLetter : JsonRequest

-(id)init_signUp :(NSString*) email iname:(NSString*)name imobileno:(NSString*)mobileno;

@end
