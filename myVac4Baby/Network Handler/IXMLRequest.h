//
//  IXMLRequest.h
//  KDSWSLayer
//
//  Created by Jermin Bazazian on 12/5/11.
//  Copyright 2011 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IXMLRequest <NSObject>

-(NSMutableDictionary*) generateHTTPPostMessage;
-(NSString*) generateSOAPMessage;

@end
