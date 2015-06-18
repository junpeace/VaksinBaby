//
//  getVaccineByIds.h
//  myVac4Baby
//
//  Created by Jun on 14/11/16.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface getVaccineByIds : JsonRequest

-(id)init_getVaccineByIds :(NSString*) language strIds :(NSString*)istrIds;

@end
