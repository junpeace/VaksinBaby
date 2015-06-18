//
//  getAllVideos.m
//  myVac4Baby
//
//  Created by jun on 10/30/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import "getAllVideos.h"

@implementation getAllVideos

-(id)init_getAllVideo :(NSString*) language
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getVideos";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];

        /*
         GET['action'] = "getVideos"
         POST['data'] = { "getVideos_data": { "language":"en/bm" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:language forKey:@"language"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getVideos_data"];
    }
    
    return self;
}

@end
