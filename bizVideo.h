//
//  bizVideo.h
//  myVac4Baby
//
//  Created by jun on 10/30/14.
//  Copyright (c) 2014 jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface bizVideo : NSObject

@property (nonatomic, strong) NSString *videoId, *videoTitle, *videoDescription, *videoMustWatch, *videoUrl, *videoDuration, *vimeoUrl, *vimeoId;
@property (nonatomic, strong) UIImage *thumbnail;

@end
