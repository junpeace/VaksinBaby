//
//  DBbase.m
//  GlobalSecureApp
//
//  Created by Tiseno Mac 2 on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBbase.h"

@implementation DBbase

-(id)init
{
    self=[super init];
    
    if(self)
    {
        databaseName = @"mayVac4BabyDb";
    }
    return self;
}
-(id)initWithDataBaseName:(NSString*)idataBaseName
{
    self=[super init];
    if(self)
    {
        databaseName=idataBaseName;
    }
    return self;
}

-(DataBaseConncetionOpenResult)openConnection
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite3",databaseName]];
    //[fileManager removeItemAtPath:writableDBPath error:&error];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success)
    {
        NSString *path=[[NSBundle mainBundle]pathForResource:databaseName ofType:@"sqlite3"];
        //[
        success = [fileManager copyItemAtPath:path
                                       toPath:writableDBPath
                                        error:&error];
        if(!success)
        {
            NSAssert1(0,@"Failed to create writable database file with Message : '%@'.",
                      [error localizedDescription]);
        }
    }
    const char* dbPath=[writableDBPath UTF8String];
    if(sqlite3_open(dbPath, &db_name)==SQLITE_OK)
    {
        return DataBaseConnectionOpened;
    }
    else
    {
        sqlite3_close(db_name);
        NSAssert1(0, @"Failed to open the database with message '%s'.", sqlite3_errmsg(db_name));
    }
    return DataBaseConnectionFailed;
}
-(void)closeConnection
{
    sqlite3_close(db_name);
}

@end
