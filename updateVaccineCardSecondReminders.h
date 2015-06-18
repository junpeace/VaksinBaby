//
//  updateVaccineCardSecondReminders.h
//  VaksinBaby
//
//  Created by jun on 4/15/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface updateVaccineCardSecondReminders : JsonRequest

-(id)init_updateVaccineCardSecondReminders :(NSString*) ichildId vaccineDoseList:(NSArray*)ivaccineDoseList;

@end
