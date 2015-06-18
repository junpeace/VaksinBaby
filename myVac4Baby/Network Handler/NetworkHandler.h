//
//  NetworkHandler.h
//  couper
//
//  Created by Tiseno Mac 2 on 5/30/13.
//  Copyright (c) 2013 Tiseno Mac 2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkHandlerDelegate.h"
#import "JsonRequest.h"
#import "JsonResponse.h"
#import "JsonResponseTranslator.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "LocalizeHelper.h"

@interface NetworkHandler : NSObject
{
    NSMutableData *responseData;
     id<NetworkHandlerDelegate> _delegate;
}
- (id<NetworkHandlerDelegate>)delegate;
- (void)setDelegate:(id<NetworkHandlerDelegate>)new_delegate;
-(void)request:(JsonRequest*)jsonRequest;
@property (nonatomic, strong) NSMutableData *responseData;

@end
 