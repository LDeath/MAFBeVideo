//
//  PlayControl.h
//  BEVideo
//
//  Created by FM on 15/12/24.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PlayerCmd{
    SnapShot = 0,
    Quqlity,
    Record
}PlayerCmd;


@protocol PlayerControlDelegate <NSObject>

-(void)UpdateCmdResult:(NSString *)msg playercmd : (PlayerCmd )playercmd;

-(void)UpdateSnapShot:(BOOL)result;

-(void)UpdateQualityMode:(int)resolution;

-(void)UpdateFlow:(int)downloadSpeed vfps:(int)vfps;

-(void)UpdateFrameRate:(int)upward download:(int)download;

-(void)UpdatePlaytime:(long)timestamp;

-(void)UpdateRecordStatus:(BOOL)isOpen msg:(NSString*)msg;

-(void)UpdateRecordTime:(long)time;

-(void)StreamBraked;


///保存截图或录像成功后回调，在此方法内把标识符写入数据库中
///@param identifier
///             if cmd=SnapShot <p> 需要判断系统版本 version>=ios8 id为(NSString *)localIdentifier 否则为(NSURL *)url<p>
///             else if cmd=Record  <p>id为(NSURL *)url
-(void)saveMediaFile:(id)identifier withTime:(NSString *)time withPlayerCmd:(PlayerCmd)cmd;

@end

@interface PlayControl : NSObject

+(instancetype)getInstance;

@property(nonatomic, weak) id<PlayerControlDelegate>playerControlDelegate;

///登陆播放器 
-(long)login:(NSString *)username password : (NSString *)password host:(NSString *)host port:(NSString *)port;

-(long)logout;

///打开摄像机
///@params channelid 摄像机资源Id
-(long)startPlayer:(NSString *)channelid;

-(void)stopPlayer;

-(void)toggleRecord;

-(void)snapShot;

-(void)snapCameraPreview;

///云镜控制
-(void)controlPtz:(NSString*)cameraId cmd:(int)cmd  isStart:(BOOL)isStart;

-(void)playSound;

-(void)stopSound;

@end
