//
//  JsonResponseTranslator.h
//  couper
//
//  Created by Tiseno Mac 2 on 6/3/13.
//  Copyright (c) 2013 Tiseno Mac 2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonResponse.h"
//#import "CRegisterResponse.h"
//#import "Clogin.h"
//#import "CloginResponse.h"
//#import "CGetNewsNPgotoResponse.h"
//#import "CGetNewsNPhotoFeeds.h"
//#import "CComment.h"

@interface JsonResponseTranslator : JsonResponse
{
    
}
-(JsonResponse*)translate:(NSDictionary*) jsonData;

@end
 