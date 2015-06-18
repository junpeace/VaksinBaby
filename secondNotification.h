//
//  secondNotification.h
//  myVac4Baby
//
//  Created by Jun on 14/11/16.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "DBbase.h"
#import "bizSecondNotification.h"

@interface secondNotification : DBbase

-(NSArray*) retrieveAllSecondNotifications;
-(NSArray*) retrieveSecondNotificationById :(NSString*)notificationId;

-(NSArray*) retrieveAllSecondNotifications_ms;
-(NSArray*) retrieveSecondNotificationById_ms :(NSString*)notificationId;

@end
