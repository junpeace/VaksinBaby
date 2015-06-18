//
//  latestNotification.m
//  myVac4Baby
//
//  Created by jun on 1/27/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "latestNotification.h"

@implementation latestNotification

-(NSArray*) retrieveAllLatestNotifications
{
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *selectSQL = [NSString stringWithFormat:@"select * from latest_notification"];
        
        sqlite3_stmt *statement;
        
        const char *select_stmt = [selectSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, select_stmt, -1, &statement, NULL);
        
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            bizLatestNotification *notification = [[bizLatestNotification alloc] init];
            
            int row0 = sqlite3_column_int(statement, 0);
            
            notification.childId = [NSString stringWithFormat:@"%d", row0];
            
            int row1 = sqlite3_column_int(statement, 1);
            
            notification.notificationType = [NSString stringWithFormat:@"%d", row1];
            
            char* row2 = (char*)sqlite3_column_text(statement, 2);
            
            if(row2)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row2];
                notification.childImgUrl = strrow;
            }
            
            int row3 = sqlite3_column_int(statement, 3);
            
            notification.notificationId = [NSString stringWithFormat:@"%d", row3];
            
            char* row4 = (char*)sqlite3_column_text(statement, 4);
            
            if(row4)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row4];
                notification.notificationFireDate = strrow;
            }
            
            [returnArr addObject:notification];
        }
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return returnArr;
}

-(DataBaseInsertionResult) insertLatestNotificationsInOneTime :(NSArray*)notificationArr
{
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSMutableString *insertSQL = [[NSMutableString alloc] init];
        
        sqlite3_stmt *statement;
        
        const char *insert_stmt;
        
        @autoreleasepool
        {
            int counter = 0;
            
            for(int i = 0; i < notificationArr.count; i++)
            {
                // insert every 495 records
                
                if(counter == 0){ [insertSQL appendString:@"insert into latest_notification(childId, pushNotificationType, childImgUrl, pushNotificationId, pushNotificationDate) values"]; }
                
                [insertSQL appendString:[NSString stringWithFormat:@"(%d, %d, '%@', %d, '%@')", [[[notificationArr objectAtIndex:i] objectForKey:@"childId"] intValue], [[[notificationArr objectAtIndex:i] objectForKey:@"pushNotificationType"] intValue], [[[notificationArr objectAtIndex:i] objectForKey:@"childImgUrl"] stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [[[notificationArr objectAtIndex:i] objectForKey:@"pushNotificationId"] intValue], [[[notificationArr objectAtIndex:i] objectForKey:@"pushNotificationDate"] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                
                counter++;
                
                if(!(i == (notificationArr.count - 1)))
                {
                    if(counter == 495)
                    {
                        [insertSQL appendString:@";"];
                        
                        insert_stmt = [insertSQL UTF8String];
                        
                        sqlite3_prepare(db_name, insert_stmt, -1, &statement, NULL);
                        
                        if(sqlite3_step(statement) == SQLITE_DONE)
                        {
                            sqlite3_finalize(statement);
                        }
                        
                        [insertSQL setString:@""];
                        
                        counter = 0;
                    }
                    else{ [insertSQL appendString:@","]; }
                }
                else
                {
                    // last record
                    
                    [insertSQL appendString:@";"];
                    
                    insert_stmt = [insertSQL UTF8String];
                    
                    sqlite3_prepare(db_name, insert_stmt, -1, &statement, NULL);
                    
                    if(sqlite3_step(statement) == SQLITE_DONE)
                    {
                        sqlite3_finalize(statement);
                    }
                }
            }
        }
        
        NSLog(@"insert notifications done");
        
        [self closeConnection];
        
        return DataBaseInsertionSuccessful;
    }
    
    return DataBaseInsertionFailed;
}

-(DataBaseDeletionResult)deleteNotificationsByChildId:(NSString*)childId
{
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from latest_notification where childId = %d ", [childId intValue]];
        
        sqlite3_stmt *statement;
        
        const char *insert_stmt = [deleteSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, insert_stmt, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            
            return DataBaseDeletionSuccessful;
        }
        
        NSAssert1(0, @"Failed to delete with message '%s'.", sqlite3_errmsg(db_name));
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return DataBaseDeletionFailed;
}

-(NSArray*) retrieveLatestNotificationByChildId :(NSString*)childId
{
    // get today date
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [dateformate stringFromDate:[NSDate date]];
        
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *selectSQL = [NSString stringWithFormat:@"select * from latest_notification where childId= %d and pushNotificationDate <= '%@' order by pushNotificationDate desc limit 1", [childId intValue], todayDate];
        
        NSLog(@"select sql : %@", selectSQL);
        
        sqlite3_stmt *statement;
        
        const char *select_stmt = [selectSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, select_stmt, -1, &statement, NULL);
        
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            bizLatestNotification *notification = [[bizLatestNotification alloc] init];
            
            int row0 = sqlite3_column_int(statement, 0);
            
            notification.childId = [NSString stringWithFormat:@"%d", row0];
            
            int row1 = sqlite3_column_int(statement, 1);
            
            notification.notificationType = [NSString stringWithFormat:@"%d", row1];
            
            char* row2 = (char*)sqlite3_column_text(statement, 2);
            
            if(row2)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row2];
                notification.childImgUrl = strrow;
            }
            
            int row3 = sqlite3_column_int(statement, 3);
            
            notification.notificationId = [NSString stringWithFormat:@"%d", row3];
            
            char* row4 = (char*)sqlite3_column_text(statement, 4);
            
            if(row4)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row4];
                notification.notificationFireDate = strrow;
            }
            
            [returnArr addObject:notification];
        }
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return returnArr;
}

@end
