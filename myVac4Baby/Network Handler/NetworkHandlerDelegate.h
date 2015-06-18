//
//  NetworkHandlerDelegate.h
//  KDSWSLayer
//
//  Created by Jermin Bazazian on 12/5/11.
//  Copyright 2011 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "XMLResponse.h"
#import "JsonResponse.h"

@protocol NetworkHandlerDelegate <NSObject>
-(void)handleRecievedResponseMessage:(NSDictionary*)responseMessage;
@end
