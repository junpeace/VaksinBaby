//
//  DataBaseConnectionOpenResult.h
//  GlobalSecureApp
//
//  Created by Tiseno Mac 2 on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

typedef enum
{ 
    DataBaseConnectionOpened,
    DataBaseConnectionFailed
} DataBaseConncetionOpenResult;

typedef enum 
{
    DataBaseInsertionSuccessful,
    DataBaseInsertionFailed
} DataBaseInsertionResult;

typedef enum 
{
    DataBaseUpdateSuccessful,
    DataBaseUpdateFailed
} DataBaseUpdateResult;

typedef enum
{
    DataBaseDeletionSuccessful,
    DataBaseDeletionFailed
} DataBaseDeletionResult;