//
//  updateVaccineCard.h
//  myVac4Baby
//
//  Created by jun on 11/12/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface updateVaccineCard : JsonRequest

-(id)init_updateVaccineCard :(NSString*) ichildId vaccineId:(NSString*) ivaccineId vaccineDoseList:(NSArray*)ivaccineDoseList;

@end
