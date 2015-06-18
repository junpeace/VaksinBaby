//
//  DBbase.h
//  GlobalSecureApp
//
//  Created by Tiseno Mac 2 on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DataBaseConnectionOpenResult.h"

@interface DBbase : NSObject {
    
    sqlite3 *db_name;
    NSString *databaseName;
}

-(id)initWithDataBaseName:(NSString*)idataBaseName;
-(DataBaseConncetionOpenResult)openConnection;
-(void)closeConnection;

@end


