//
//  getChildVaccineCard.h
//  myVac4Baby
//
//  Created by jun on 11/12/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface getChildVaccineCard : JsonRequest

-(id)init_getChildVaccineCard :(NSString*) ichildId vaccineId:(NSString*) ivaccineId;

@end
