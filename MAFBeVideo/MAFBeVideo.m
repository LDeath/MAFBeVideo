//
//  MAFBeVideo.m
//  ShareHelp
//
//  Created by 高赛 on 2017/7/12.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "MAFBeVideo.h"

@interface MAFBeVideo()

@end

@implementation MAFBeVideo

static id instance = nil;
+ (MAFBeVideo *)sharedInstance {
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        instance = [[MAFBeVideo alloc] init];
    });
    return instance;
}

@end
