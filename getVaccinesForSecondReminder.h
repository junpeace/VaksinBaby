//
//  getVaccinesForSecondReminder.h
//  VaksinBaby
//
//  Created by jun on 4/14/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface getVaccinesForSecondReminder : JsonRequest

-(id)init_getVaccinesForSecondReminder :(NSString*) language strIds :(NSString*)istrIds strMonth:(NSString*) imonth strChildId:(NSString*) ichildId;

@end
