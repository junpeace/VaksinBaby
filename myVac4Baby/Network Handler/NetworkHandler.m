//
//  NetworkHandler.m
//  couper
//
//  Created by Tiseno Mac 2 on 5/30/13.
//  Copyright (c) 2013 Tiseno Mac 2. All rights reserved.
//

#import "NetworkHandler.h"

@implementation NetworkHandler

-(id)init
{
    self=[super init];
    if(self)
    {
    }
    return self;
}

- (id)delegate
{
	return _delegate;
}

-(void)setDelegate:(id)new_delegate
{
	if (_delegate)
	{
		//[_delegate release];
	}
	//[new_delegate retain];
    _delegate=new_delegate;
}

-(BOOL)NetworkStatus
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus==NotReachable);
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"hihihi1");
//            if (buttonIndex == 0)
//            {
//                NSLog(@"hihihi2");
//                [SVProgressHUD dismiss];
//            }
//    
//}

-(void)request:(JsonRequest*)jsonRequest
{
    if(![self NetworkStatus])
    {
        [SVProgressHUD dismiss];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"You're not connected to Internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString            *stringBoundary, *contentType, *baseURLString, *urlString;
        NSData              *imageData;
        NSURL               *url;
        NSMutableURLRequest *urlRequest;
        NSMutableData       *postBody;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonRequest.jsonDicttbl options:kNilOptions error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        // Create POST request from message, imageData, username and password
        baseURLString   =[NSString stringWithFormat:@"%@%@", jsonRequest.webserviceURL,jsonRequest.Action];
        urlString       = [NSString stringWithFormat:@"%@", baseURLString];
        url             = [NSURL URLWithString:urlString];
        urlRequest      = [[NSMutableURLRequest alloc] initWithURL:url];
        //        urlRequest.timeoutInterval = 10800;
        urlRequest.timeoutInterval = 120;
        [urlRequest setHTTPMethod:@"POST"];
        
        NSLog(@"jsonString>>>%@",jsonString);
        
        // Set the params
        NSString *path = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
        imageData = [[NSData alloc] initWithContentsOfFile:path];
        
        // Setup POST body
        stringBoundary = @"0xKhTisenomLbOuNdArY";
        contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
        
        
        //        NSString *strURL = [loc_address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // requesting weather for this location ...
        //        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.google.com/ig/api?weather=%@", strURL]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
        //        [req setHTTPMethod:@"POST"];
        //        [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        // Setting up the POST request's multipart/form-data body
        postBody = [NSMutableData data];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Disposition: form-data; name=\"data\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithString:jsonString] dataUsingEncoding:NSUTF8StringEncoding]];  // So Light Table show up as source in Twitter post
        
//        if ([jsonRequest isKindOfClass:[CUploadPhoto class]] && 1 == 1 ) {
//            CUploadPhoto *photoRequest = (CUploadPhoto *)jsonRequest;
//            NSString *imageFileName = [NSString stringWithFormat:@"photo.jpeg"];
//            [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n",imageFileName] dataUsingEncoding:NSUTF8StringEncoding]];
//            //[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"\r\n\n\n"]dataUsingEncoding:NSUTF8StringEncoding]];
//            [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            [postBody appendData:photoRequest.photoData];
////            NSLog(@"photoRequest.photoData>>>%d",[photoRequest.photoData length]);
//            [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        }
        
        
        
        
        [urlRequest setHTTPBody:postBody];
        
        NSURLConnection *conn = [[NSURLConnection alloc] init];
        (void)[conn initWithRequest:urlRequest delegate:self];
    }
    
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:
(NSURLResponse*)response
{
    NSLog(@"here didReceiveResponse1");
    responseData = [[NSMutableData alloc] init];
    
    [responseData setLength:0];
    NSLog(@"here didReceiveResponse2");

}

-(void) connection:(NSURLConnection *) connection didReceiveData:
(NSData *) data
{
//    if (!responseData)
//    {
//        responseData = [[NSMutableData alloc] init];
//        responseData = [[ data subdataWithRange:(NSRange){ 0, MIN( 2048, data.length ) } ] mutableCopy ] ;
//        [ responseData setLength:2048 ] ;

//    [NSMutableData dataWithData:data];
//    }
//    [responseData setLength:0];
    [responseData appendData:data];
//    [responseData increaseLengthBy:1024.0f * 1024.0f];
    
    
//    [responseData appendData:data];
//    NSLog(@"didReceiveData>>>%f",responseData.length/1024.0f/1024.0f);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: LocalizedString(@"Error")
                                                    message:LocalizedString(@"Sorry Mommy, looks like we cannot communicate with the servers. Please check your internet connection and try again.")
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [SVProgressHUD dismiss];    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"here connectionDidFinishLoading");

    NSError *e = nil;
    
//    NSString *js = @"{\"result\":\"1\",\"action\":\"get_photos_feed\",\"data\":[{\"photo_id\":\"6\",\"photo_owner_id\":\"42\",\"photo_owner_name\":\"company 42\",\"photo_owner_profile_img\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"account_type\":\"0\",\"create_date\":\"2013-05-30 05:56:28\",\"comments\":[{\"comment_user_id\":\"30\",\"name\":\"desmond 30\",\"profile_picture_url\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"message\":\"user 30 comment in photo 6 (1)\"}]},{\"photo_id\":\"3\",\"photo_owner_id\":\"35\",\"photo_owner_name\":\"desmond 35\",\"photo_owner_profile_img\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"account_type\":\"1\",\"create_date\":\"2013-05-30 05:54:29\",\"comments\":[{\"comment_user_id\":\"42\",\"name\":\"company 42\",\"profile_picture_url\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"message\":\"user 42 comment in photo 3 (1)\"}]},{\"photo_id\":\"2\",\"photo_owner_id\":\"35\",\"photo_owner_name\":\"desmond 35\",\"photo_owner_profile_img\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"account_type\":\"1\",\"create_date\":\"2013-05-30 05:54:03\",\"comments\":[{\"comment_user_id\":\"42\",\"name\":\"company 42\",\"profile_picture_url\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"message\":\"user 42 comment in photo 2 (2)\"},{\"comment_user_id\":\"35\",\"name\":\"desmond 35\",\"profile_picture_url\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"message\":\"user 35 comment in photo 2 (1)\"}]},{\"photo_id\":\"1\",\"photo_owner_id\":\"35\",\"photo_owner_name\":\"desmond 35\",\"photo_owner_profile_img\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"account_type\":\"1\",\"create_date\":\"2013-05-30 05:52:08\",\"comments\":[{\"comment_user_id\":\"42\",\"name\":\"company 42\",\"profile_picture_url\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"message\":\"user 42 comment in photo 1 (4)\"},{\"comment_user_id\":\"30\",\"name\":\"desmond 30\",\"profile_picture_url\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"message\":\"user 30 comment in photo 1 (3)\"},{\"comment_user_id\":\"35\",\"name\":\"desmond 35\",\"profile_picture_url\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"message\":\"user 35 comment in photo 1 (2)\"},{\"comment_user_id\":\"35\",\"name\":\"desmond 35\",\"profile_picture_url\":\"http:\/\/24.media.tumblr.com\/tumblr_mbhc6qPOdM1r1thfzo1_1280.jpg\",\"message\":\"user 35 comment in photo 1 (1)\"}]}],\"message\":\"\",\"message_code\":\"\"}";
    
//    NSData *rrData=[js dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: &e];

    // set different language display text
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"languagePreference"] isEqualToString:@"en"])
    {     LocalizationSetLanguage(@"en"); }
    else
    {  LocalizationSetLanguage(@"ms"); }
    
    if (jsonData != nil) { }
    else{
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: LocalizedString(@"Error")
                                                        message:LocalizedString(@"Sorry Mommy, looks like we cannot communicate with the servers. Please check your internet connection and try again.")
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if ([_delegate respondsToSelector:@selector(handleRecievedResponseMessage:)])
    {
        [_delegate handleRecievedResponseMessage:jsonData];
    }
    
    responseData = nil;
}

@end
