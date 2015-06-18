//
//  firstNotification.h
//  myVac4Baby
//
//  Created by Jun on 14/11/16.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "DBbase.h"
#import "bizFirstNotification.h"

@interface firstNotification : DBbase

-(NSArray*) retrieveAllFirstNotifications;
-(NSArray*) retrieveFirstNotificationById :(NSString*)notificationId;

-(NSArray*) retrieveAllFirstNotifications_ms;
-(NSArray*) retrieveFirstNotificationById_ms :(NSString*)notificationId;

@end
