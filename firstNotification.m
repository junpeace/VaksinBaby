//
//  firstNotification.m
//  myVac4Baby
//
//  Created by Jun on 14/11/16.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "firstNotification.h"

@implementation firstNotification

-(NSArray*) retrieveAllFirstNotifications
{
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *selectSQL = [NSString stringWithFormat:@"select * from first_push_notification_en"];
        
        sqlite3_stmt *statement;
        
        const char *select_stmt = [selectSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, select_stmt, -1, &statement, NULL);
        
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            bizFirstNotification *notification = [[bizFirstNotification alloc] init];
            
            int row0 = sqlite3_column_int(statement, 0);
            
            notification.notificationId = [NSString stringWithFormat:@"%d", row0];
            
            char* row1 = (char*)sqlite3_column_text(statement, 1);
            
            if(row1)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row1];
                notification.notificationTitle = strrow;
            }
            
            char* row2 = (char*)sqlite3_column_text(statement, 2);
            
            if(row2)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row2];
                notification.vaccineTitle = strrow;
            }
            
            char* row3 = (char*)sqlite3_column_text(statement, 3);
            
            if(row3)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row3];
                notification.vaccineDate = strrow;
            }
            
            char* row4 = (char*)sqlite3_column_text(statement, 4);
            
            if(row4)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row4];
                notification.notificationDescUrl = strrow;
            }
            
            char* row5 = (char*)sqlite3_column_text(statement, 5);
            
            if(row5)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row5];
                notification.fkVaccinePreventableDiseaseId = strrow;
            }
            
            char* row6 = (char*)sqlite3_column_text(statement, 6);
            
            if(row6)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row6];
                notification.preventableDiseaseDescUrl = strrow;
            }
            
            [returnArr addObject:notification];
        }
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return returnArr;
}

-(NSArray*) retrieveAllFirstNotifications_ms
{
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *selectSQL = [NSString stringWithFormat:@"select * from first_push_notification_bm"];
        
        sqlite3_stmt *statement;
        
        const char *select_stmt = [selectSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, select_stmt, -1, &statement, NULL);
        
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            bizFirstNotification *notification = [[bizFirstNotification alloc] init];
            
            int row0 = sqlite3_column_int(statement, 0);
            
            notification.notificationId = [NSString stringWithFormat:@"%d", row0];
            
            char* row1 = (char*)sqlite3_column_text(statement, 1);
            
            if(row1)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row1];
                notification.notificationTitle = strrow;
            }
            
            char* row2 = (char*)sqlite3_column_text(statement, 2);
            
            if(row2)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row2];
                notification.vaccineTitle = strrow;
            }
            
            char* row3 = (char*)sqlite3_column_text(statement, 3);
            
            if(row3)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row3];
                notification.vaccineDate = strrow;
            }
            
            char* row4 = (char*)sqlite3_column_text(statement, 4);
            
            if(row4)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row4];
                notification.notificationDescUrl = strrow;
            }
            
            char* row5 = (char*)sqlite3_column_text(statement, 5);
            
            if(row5)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row5];
                notification.fkVaccinePreventableDiseaseId = strrow;
            }
            
            char* row6 = (char*)sqlite3_column_text(statement, 6);
            
            if(row6)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row6];
                notification.preventableDiseaseDescUrl = strrow;
            }
            
            [returnArr addObject:notification];
        }
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return returnArr;
}

-(NSArray*) retrieveFirstNotificationById :(NSString*)notificationId
{
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *selectSQL = [NSString stringWithFormat:@"select * from first_push_notification_en where id= %d", [notificationId intValue]];
                
        sqlite3_stmt *statement;
        
        const char *select_stmt = [selectSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, select_stmt, -1, &statement, NULL);
        
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            bizFirstNotification *notification = [[bizFirstNotification alloc] init];
            
            int row0 = sqlite3_column_int(statement, 0);

            notification.notificationId = [NSString stringWithFormat:@"%d", row0];
            
            char* row1 = (char*)sqlite3_column_text(statement, 1);
            
            if(row1)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row1];
                notification.notificationTitle = strrow;
            }
            
            char* row2 = (char*)sqlite3_column_text(statement, 2);
            
            if(row2)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row2];
                notification.vaccineTitle = strrow;
            }
            
            char* row3 = (char*)sqlite3_column_text(statement, 3);
            
            if(row3)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row3];
                notification.vaccineDate = strrow;
            }
            
            char* row4 = (char*)sqlite3_column_text(statement, 4);
            
            if(row4)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row4];
                notification.notificationDescUrl = strrow;
            }
            
            char* row5 = (char*)sqlite3_column_text(statement, 5);
            
            if(row5)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row5];
                notification.fkVaccinePreventableDiseaseId = strrow;
            }
            
            char* row6 = (char*)sqlite3_column_text(statement, 6);
            
            if(row6)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row6];
                notification.preventableDiseaseDescUrl = strrow;
            }
            
            [returnArr addObject:notification];
        }
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return returnArr;
}

-(NSArray*) retrieveFirstNotificationById_ms :(NSString*)notificationId
{
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *selectSQL = [NSString stringWithFormat:@"select * from first_push_notification_bm where id= %d", [notificationId intValue]];
        
        sqlite3_stmt *statement;
        
        const char *select_stmt = [selectSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, select_stmt, -1, &statement, NULL);
        
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            bizFirstNotification *notification = [[bizFirstNotification alloc] init];
            
            int row0 = sqlite3_column_int(statement, 0);
            
            notification.notificationId = [NSString stringWithFormat:@"%d", row0];
            
            char* row1 = (char*)sqlite3_column_text(statement, 1);
            
            if(row1)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row1];
                notification.notificationTitle = strrow;
            }
            
            char* row2 = (char*)sqlite3_column_text(statement, 2);
            
            if(row2)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row2];
                notification.vaccineTitle = strrow;
            }
            
            char* row3 = (char*)sqlite3_column_text(statement, 3);
            
            if(row3)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row3];
                notification.vaccineDate = strrow;
            }
            
            char* row4 = (char*)sqlite3_column_text(statement, 4);
            
            if(row4)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row4];
                notification.notificationDescUrl = strrow;
            }
            
            char* row5 = (char*)sqlite3_column_text(statement, 5);
            
            if(row5)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row5];
                notification.fkVaccinePreventableDiseaseId = strrow;
            }
            
            char* row6 = (char*)sqlite3_column_text(statement, 6);
            
            if(row6)
            {
                NSString *strrow = [NSString stringWithUTF8String:(char*)row6];
                notification.preventableDiseaseDescUrl = strrow;
            }
            
            [returnArr addObject:notification];
        }
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return returnArr;
}

@end
