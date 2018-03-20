//
//  RealTimePlayer.m
//  BEVideo
//
//  Created by FM on 15/12/24.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "RealTimePlayer.h"
#import "PlayControl.h"

@interface RealTimePlayer ()

@property PlayerStatus currentStatus;

@end

static PlayControl *playerControl;

@implementation RealTimePlayer


+(id)getInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        playerControl = [PlayControl getInstance];
        return [[self alloc] init];
    });
}

-(void)startPlayerWithChannelid:(NSString *)channelid
{
    channelid =  channelid == nil ? @"" : channelid;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [playerControl startPlayer:channelid];
    });

}

-(void)snapCameraPreview
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [playerControl snapCameraPreview];
    });
}

-(void)stopPlayer
{
    Lg(@"-----  stopPlayer ");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //
        [playerControl stopPlayer];
    });
    
   
}

@end
