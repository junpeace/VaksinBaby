//
//  latestNotification.h
//  myVac4Baby
//
//  Created by jun on 1/27/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "DBbase.h"
#import "bizLatestNotification.h"

@interface latestNotification : DBbase

-(NSArray*) retrieveAllLatestNotifications;
-(DataBaseInsertionResult) insertLatestNotificationsInOneTime :(NSArray*)notificationArr;
-(DataBaseDeletionResult) deleteNotificationsByChildId:(NSString*)childId;
-(NSArray*) retrieveLatestNotificationByChildId :(NSString*)childId;

@end
