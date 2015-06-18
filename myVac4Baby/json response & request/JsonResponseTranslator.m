//
//  JsonResponseTranslator.m
//  couper
//
//  Created by Tiseno Mac 2 on 6/3/13.
//  Copyright (c) 2013 Tiseno Mac 2. All rights reserved.
//

#import "JsonResponseTranslator.h"

@implementation JsonResponseTranslator

-(JsonResponse*)translate:(NSDictionary*) jsonData
{
    //NSLog(@"jsonData: %@: ", jsonData);
    JsonResponse *message=nil;
    
//    if ([[jsonData objectForKey:@"action"] isEqualToString:@"login"]) {
//        
//        //NSLog(@"jsonData: %@: ", jsonData);
//
//        message=[self translateUserlogin:jsonData];
//        
//    }else if ([[jsonData objectForKey:@"action"] isEqualToString:@"get_photos_feed"]) {
//        
//        //NSLog(@"get_photo_feeds jsonData: %@: ", jsonData);
//
//        message=[self translateGetNewsNPhoto:jsonData];
//        
//    }
//    else
//	{
//		NSLog(@"Error decoding the document: %@: ", [self class]);
//	}
 
    
    
    return message;
}
//
//-(JsonResponse*)translateUserlogin:(NSDictionary*) jsonData
//{
//    CloginResponse *msg=nil;
//    
//    if (jsonData) {
//        msg=[[CloginResponse alloc]init];
//        
//        msg.result_Status=[jsonData objectForKey:@"result"];
//        //msg.result_data=[jsonData objectForKey:@"data"];
//        
//        //NSLog(@"msg.result_data>>>%@",msg.result_data);
//        
//        //NSArray *DataArr=[jsonData objectForKey:@"data"];
//        
////        for(id key in DataArr)
////        {
////            NSLog(@"key photo_id>>>%@",[key objectForKey:@"photo_id"]);
////            
////            
//////            Clogin *gclogin=[[Clogin alloc]init ];
//////            gclogin.login_status=[key objectForKey:@"status"];
//////            NSLog(@"res gclogin.login_status>>>%@",gclogin.login_status);
////            
////            
////        }
//        
//        
//        msg.result_message=[jsonData objectForKey:@"message"];
//
//    }
//
//    return msg;
//}
//
//-(JsonResponse*)translateGetNewsNPhoto:(NSDictionary*) jsonData
//{
//    CGetNewsNPgotoResponse *msg=nil;
//    
//    if (jsonData) {
//        msg=[[CGetNewsNPgotoResponse alloc]init];
//        
//        msg.result_Status=[jsonData objectForKey:@"result"];
//        //msg.result_data=[jsonData objectForKey:@"data"];
//        
//        //NSLog(@"msg.result_data>>>%@",msg.result_data);
//        
//        NSArray *DataArr=[jsonData objectForKey:@"data"];
//        
//        //NSLog(@"DataArr.count%d",DataArr.count);
//        
//        NSMutableArray *DataArrayList=[[NSMutableArray alloc]initWithCapacity:DataArr.count];
//        
//        
//        
//        
//                for(id key in DataArr)
//                {
//                    CGetNewsNPhotoFeeds *gobjct=[[CGetNewsNPhotoFeeds alloc]init ];
//                    //NSLog(@"key photo_id>>>%@",[key objectForKey:@"photo_id"]);
//                    
//        
//                    
//                    gobjct.photo_id=[key objectForKey:@"photo_id"];
//                    //NSLog(@"gobjct.photo_id>>>%@",gobjct.photo_id);
//                    //gobjct.comment=[key objectForKey:@"comments"];
//                    
//                    NSMutableArray *subDataArr=[key objectForKey:@"comments"];
//                    for(id subkey in subDataArr)
//                    {
//                        CComment *subobjct=[[CComment alloc]init];
//                        subobjct.comment_user_id=[subkey objectForKey:@"comment_user_id"];
//                        subobjct.comment_name=[subkey objectForKey:@"name"];
//                        
//                        [subDataArr addObject:subobjct];
//                    }
//                    
//                    gobjct.commentArr=subDataArr;
//                    
//                    //NSLog(@"gobjct.commentArr>>>%@",gobjct.commentArr);
//        
//                    [DataArrayList addObject:gobjct];
//        
//               }
//        msg.result_data=DataArrayList;
//        
//        msg.result_message=[jsonData objectForKey:@"message"];
//        
//    }
//    
//    return msg;
//}
@end
