//
//  RealTimePlayer.h
//  BEVideo
//
//  Created by FM on 15/12/24.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    UNKNOWN,
    MASTERCONNECTING,
    CAMERAOFFLINE,
    MASTERDISCONNECT,
    RELAYCONNECTING,
    RELAYDISCONNECT,
    PLAYING,
    PLAYWAITTING,
    INTERRUPT,
    BACKGROUNDPLAY,
    BACKGROUNDSTOP
}PlayerStatus;

@protocol PlayerStatusDelegate <NSObject>

-(void)UpdateStatus:(PlayerStatus)status msg:(NSString *)msg;

@end

@interface RealTimePlayer : NSObject

+(id)getInstance;

-(void)startPlayerWithChannelid:(NSString *) channelid;

-(void)stopPlayer;

-(void)snapCameraPreview;


@end
