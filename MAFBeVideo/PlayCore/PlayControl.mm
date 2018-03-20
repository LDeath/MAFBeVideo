//
//  PlayControl.m
//  BEVideo
//
//  Created by FM on 15/12/24.
//  Copyright © 2015年 BlueEye. All rights reserved.
//   ipv6:  http://mrpeak.cn/blog/ipv6/
//          https://github.com/ZeroYang/2016_study/blob/885fe5cb34d42f5a02e0857f8187e3561312bbbe/Unity3D/XUPorter_Demo/Assets/Plugins/iOS/Common/IPV6Adapter.m
//
//

#import "PlayControl.h"
#include "NvsJPlayerSDK.h"
#import "ALAssetsLibrary+custom.h"
#import "AppConfig.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <err.h>




@interface PlayControl()<PlayerControlDelegate>
@property BOOL mIsRecord;
@property (nonatomic,strong) NSDate *mRecordBeginTime;
@property (nonatomic,strong) NSString *channelid;
@property long mRecordTime;

@property(nonatomic,copy)NSString *mRecordPath;

@property(nonatomic,copy)NSString *mRecordCameraName;

@end

@implementation PlayControl

long mPlayerId;


+(instancetype)getInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[PlayControl alloc]init];
    });
}

///码流回调
///@param lHandle
///@param vbps 视频码流
///@param abps 音频码流
///@param vfps 视频帧率
///@param afps 音频帧率
LONG NVS_CALLBACK onUpdateStatus(LONG lHandle,LONG vbps,LONG abps,LONG vfps,LONG afps,LONG dwUser){
    
    if(mPlayerId != lHandle)return 0;
    
    int downloadSpeed = (int)((vbps + abps) / 1024);
    
    PlayControl *playControl = [PlayControl getInstance];
    [playControl onUpdateFlow:downloadSpeed vfps:(int)vfps];
    
    return 0;
}

LONG NVS_CALLBACK onPlayerMsg(LONG  lHandle,LONG  lCommand,LLONG para1,LLONG para2,LONG  dwUser){
    PlayControl *playerControl = [PlayControl getInstance];
    switch (lCommand) {
            
        case JPLAYER_MSG_SUBSCRIBE_FAILED://打开视频失败
            break;
            
        case JPLAYER_MSG_VIDEO_IS_READY://视频缓存完毕
            
            [playerControl onVideoReady_updatePlaytime:para1];
            break;
        case JPLAYER_MSG_VIDEO_RESOLUTION://分辨率改变
            break;
            
        case JPLAYER_MSG_SESSION_CLOSED://播放器出现错误或被关闭
            break;
            
        case JPLAYER_MSG_SESSION_CONNECTED://连接上流媒体
            break;
            
            
        case JPLAYER_MSG_RECORD_ERROR://录像出现错误
            [playerControl onRecordVideo:JPLAYER_MSG_RECORD_ERROR para1:para1];
            break;
        case JPLAYER_MSG_RECORD_ENDSTREAM://录像被关闭
            [playerControl onRecordVideo:JPLAYER_MSG_RECORD_ENDSTREAM para1:para1];
            break;
        case JPLAYER_MSG_RECORD_INVALID_FILE://无效的录像文件
            [playerControl onRecordVideo:JPLAYER_MSG_RECORD_INVALID_FILE para1:para1];
            break;
            
        case JPLAYER_MSG_RECORD_TIMER://录像时间回调
            [playerControl onRecordVideo:JPLAYER_MSG_RECORD_TIMER para1:para1];
            break;
            
            
    }
    
    return 0;
}

#pragma mark - player option
-(LONG)login:(NSString *)username password:(NSString *)password host:(NSString *)host port:(NSString *)port
{
    _mIsRecord = NO;
    
    NVS_JPlayer_Init(2);
    
    JPlayer_Info Info;
    LONG ok = NVS_JPlayer_GetLibraryInfo(&Info);
    if (ok == JPLAYER_MSG_NORMAL)
    {
        printf("%s\n",Info.m_version);
    }
    
    //    struct addrinfo hints, *res,*res0;
    //    int error, s;
    //    const char *cause = NULL;
    //
    //    const char *ipv4_str = [host UTF8String];
    //
    //    memset(&hints, 0, sizeof(hints));
    //    hints.ai_family = PF_UNSPEC;
    //    hints.ai_socktype = SOCK_STREAM;
    //    hints.ai_flags = AI_DEFAULT;
    //    error = getaddrinfo(ipv4_str,[port UTF8String], &hints, &res0);
    //
    //    if(error){
    //        errx(1,"%s",gai_strerror(error));
    //    }
    //
    //    char ipstr[INET_ADDRSTRLEN];
    //
    //    //ex:https://github.com/ZeroYang/2016_study/blob/885fe5cb34d42f5a02e0857f8187e3561312bbbe/Unity3D/XUPorter_Demo/Assets/Plugins/iOS/Common/IPV6Adapter.m
    //
    //    for(res = res0; res; res = res-> ai_next){
    //
    //        const char *ipverstr;
    //        switch (res->ai_family) {
    //            case AF_INET:
    //                ipverstr = "IPv4";
    //                break;
    //            case  AF_INET6:
    //                ipverstr = "IPv6";
    //                break;
    //            default:
    //                ipverstr = "unknown";
    //                break;
    //        }
    //
    //
    //        struct in_addr *addr;
    //        if(res->ai_family == AF_INET){
    //            struct sockaddr_in *ipv = (struct sockaddr_in *)res->ai_addr;
    //            ipv->sin_port = htons([port intValue]);
    //            addr = &(ipv->sin_addr);
    //
    //            inet_ntop(res->ai_family,addr,ipstr,sizeof ipstr);
    //            printf("%s : %s\n",ipverstr,ipstr);
    //        }
    //        else{
    //            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)res->ai_addr;
    //            ipv6->sin6_port = htons([port intValue]);
    //
    //            addr = (struct in_addr *)&(ipv6->sin6_addr);
    //
    //            NSString* ipStr = nil;
    //
    //            char dstStr[INET6_ADDRSTRLEN];
    //            char srcStr[INET6_ADDRSTRLEN];
    //
    //            memcpy(srcStr, &res->ai_addr, sizeof(struct in6_addr));
    //
    //            if(inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL){
    //                ipStr = [NSString stringWithUTF8String:dstStr];
    //            }
    //
    //            printf("%s : %@\n",ipverstr,ipStr);
    //
    //
    //        }
    //    }
    
    JPlayer_LoginPara sess;
    strcpy(sess.m_serverIp,[host UTF8String]);
    strcpy(sess.m_userName, [username UTF8String]);
    strcpy(sess.m_password, [password UTF8String]);
    sess.m_linkType = 2;
    sess.m_serverPort = [port intValue];
    ok = NVS_JPlayer_Login(&sess);
    printf("login===%ld\n",ok);
    
    return ok;
}

-(long)logout
{
    return NVS_JPlayer_Logout();
}

-(long)startPlayer:(NSString *)channelid
{
    NVS_JPlayer_SetMsgCallBack(onPlayerMsg,0);
    
    mPlayerId= NVS_JPlayer_Open();
    self.channelid = channelid;
    if(mPlayerId == 0)
        return mPlayerId;
    
    int playMode = [AppConfig getPlayMode] ? 1 : 0;
    NVS_JPlayer_SetPlayMode(playMode);
    
    NVS_JPlayer_SetBDCallBack(mPlayerId,5,onUpdateStatus,0);
    
    BOOL isSubStream = [AppConfig getStreamMode];
    NSString *resId = [NSString stringWithFormat:@"%@%@",channelid,(isSubStream ? @"" :@"_1")];
    
    
    Lg("JPlayer_Open===%ld resId=%@ 播放模式:%@ 码流:%@",mPlayerId,resId,(playMode == 0 ? @"实时优先" :@"流畅优先"),(isSubStream? @"主码流" : @"子码流"));
    
    JPlayer_PlaySession pSess;
    strcpy(pSess.m_channelId, [resId UTF8String]);
    LONG ret = NVS_JPlayer_Play_Live(mPlayerId,&pSess);
    
    printf("JPlayer_Play_Live===%ld\n",ret);
    if (ret != JPLAYER_MSG_NORMAL)
    {
        NVS_JPlayer_Close(mPlayerId);
        mPlayerId = -1;
        
    }
    
    if(mPlayerId != 0)
        NVS_JPlayer_PlaySound(mPlayerId);
    
    return mPlayerId;
    
}

-(void)stopPlayer
{
    NVS_JPlayer_Stop(mPlayerId);
    NVS_JPlayer_StopSound(mPlayerId);
    NVS_JPlayer_Close(mPlayerId);
}

- (void)onUpdateFlow:(int)flow vfps:(int)vfps {
    [_playerControlDelegate UpdateFlow:flow vfps:vfps];
}

- (void)onVideoReady_updatePlaytime:(long long)para1 {
    [_playerControlDelegate UpdatePlaytime:(long)para1];
}

-(void)onRecordVideo : (int)MSG_RECROD_CALLBACK  para1:(long long) para1
{
    
    
    switch (MSG_RECROD_CALLBACK) {
        case JPLAYER_MSG_RECORD_ERROR://录像出现错误
            
            _mIsRecord = NO;
            
            Lg(@"---  录像出现错误 ----");
            
        {
            NSFileManager *fileManger = [[NSFileManager alloc] init];
            [fileManger removeItemAtURL:[NSURL fileURLWithPath:_mRecordPath] error:nil];
            [_playerControlDelegate UpdateRecordStatus:NO msg:@"无法继续录像，请检查手机权限或空间是否不足"];
            
        }
            break;
        case JPLAYER_MSG_RECORD_ENDSTREAM://录像被关闭
            
            _mIsRecord = NO;
            
            Lg(@"--- 录像被关闭 ----");
            
            
            //videoPath是你视频文件的路径，我这里是加载工程中的
        {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:_mRecordPath]
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            if (error) {
                                                NSLog(@"Save video fail:%@",error);
                                                [_playerControlDelegate UpdateRecordStatus:NO msg:@"录像保存失败"];
                                                
                                            } else {
                                                NSLog(@"Save video succeed. %@",assetURL);
                                                [_playerControlDelegate UpdateRecordStatus:NO msg:@"录像已保存在我的相册"];
                                                NSFileManager *fileManger = [[NSFileManager alloc] init];
                                                [fileManger removeItemAtURL:[NSURL fileURLWithPath:_mRecordPath] error:nil];
                                                
                                                NSString *time = [[_mRecordPath lastPathComponent] componentsSeparatedByString:@"."][0];
                                                
                                                [_playerControlDelegate saveMediaFile:[assetURL absoluteString] withTime:time withPlayerCmd:Record];
                                            }
                                        }];
            
            break;
        }
        case JPLAYER_MSG_RECORD_INVALID_FILE://无效的录像文件
            
            Lg(@"--- 无效的录像文件 ----");
            
            _mIsRecord = NO;
            
        {
            //如果录像文件存在  删除录像文件
            //删除_mRecordPath
            
            NSString *reason;
            
            double dateDifference = [_mRecordBeginTime timeIntervalSinceNow];
            
            if(dateDifference > 3 && _mRecordTime > 3){
                reason = @"网络较差,录制失败";
            }else{
                reason = @"录像时间过短，录制失败";
            }
            
            NSFileManager *fileManger = [[NSFileManager alloc] init];
            [fileManger removeItemAtURL:[NSURL fileURLWithPath:_mRecordPath] error:nil];
            
            [_playerControlDelegate UpdateRecordStatus:NO msg:reason];
            break;
        }
            
        case JPLAYER_MSG_RECORD_TIMER://录像时间回调
            [_playerControlDelegate UpdateRecordTime:para1];
            
            break;
            
    }
    
}

-(void)toggleRecord
{
    if (mPlayerId == 0) {
        return;
    }
    
    Lg(@"_mIsRecord:%hhd",_mIsRecord);
    
    if(_mIsRecord == YES){
        [self stopReocrd];
    }else{
        _mIsRecord = [self beginRecord];
    }
    
}

-(void)stopReocrd
{
    Lg(@"---- 关闭录像");
    NVS_JPlayer_StopRecord(mPlayerId);
}

-(BOOL)beginRecord
{
    
    Lg(@"---- 开始录像");
    
    //手机存储空间不足 不能录
    
    //日期转换为字符串
    //实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _mRecordBeginTime = [NSDate date];
    NSString *currentDateStr = [dateFormat stringFromDate:_mRecordBeginTime];
    
    //    NSBundle *bundle=[NSBundle mainBundle];
    //    _mRecordPath=[bundle pathForResource:currentDateStr ofType:@"mp4"];
    
    NSArray * paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //Documents 下面创建album文件夹
    //strTitle:当前摄像头
    NSString * fileDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/video/%@",@"username_1",@"test" ]];
    
    //创建目录
    [fileManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString * pictureName = [NSString stringWithFormat:@"%@.mp4",currentDateStr];
    //NSLog(@"pictureName:%@",pictureName);
    _mRecordPath = [fileDirectory stringByAppendingPathComponent:pictureName];
    
    
    long result = NVS_JPlayer_StartRecord(mPlayerId,JPLAYER_MP4_VIDEO_TRACK | JPLAYER_MP4_VIDEO_TRACK,[_mRecordPath UTF8String]);
    
    Lg(@"_mRecordPath:%@",_mRecordPath);
    
    [_playerControlDelegate UpdateRecordStatus:YES msg:nil];
    
    
    return result == JPLAYER_MSG_NORMAL;
}

-(void)snapCameraPreview;
{
    NSArray * paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    //Documents 下面创建album文件夹
    //strTitle:当前摄像头
    NSString * fileDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/album/%@",@"config",@"cache" ]];
    
    //创建目录
    [fileManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    NSString * saveImagePath = [fileDirectory stringByAppendingPathComponent:@"tempCache.png"];
    
    BOOL deleteStatus = [fileManager removeItemAtPath:saveImagePath error:nil];
    
    long result = NVS_JPlayer_Snap(mPlayerId, [saveImagePath UTF8String]);
    
    Lg(@">>>>  result %d saveImagePath %@",(int)result,saveImagePath);
    
    
    if(result != JPLAYER_MSG_NORMAL){
        return;
    }
    
    
    NSData *data = [NSData dataWithContentsOfFile:saveImagePath];
    
    UIImage *image = [UIImage imageWithData:data];
    
    NSString *path = Url_Capture(self.channelid);
    
    [[SDImageCache sharedImageCache] storeImage:image forKey:path toDisk:YES];
}

-(void)snapShot
{
    
    NSArray * paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //Documents 下面创建album文件夹
    //strTitle:当前摄像头
    NSString * fileDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/album/%@",@"username_1",@"test" ]];
    
    //创建目录
    [fileManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    //获取系统时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * date = [formatter stringFromDate:[NSDate date]];
    NSString * pictureName = [NSString stringWithFormat:@"%@.png",date];
    //NSLog(@"pictureName:%@",pictureName);
    NSString * saveImagePath = [fileDirectory stringByAppendingPathComponent:pictureName];
    
    
    long result = NVS_JPlayer_Snap(mPlayerId, [saveImagePath UTF8String]);
    
    
    
    Lg(@">>>>  result %d saveImagePath %@",(int)result,saveImagePath);
    
    
    NSData *data = [NSData dataWithContentsOfFile:saveImagePath];
    
    UIImage *image = [UIImage imageWithData:data];
    
    if(result == JPLAYER_MSG_NORMAL){
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        [library saveImage:image toAlbum:DEFAULT_FLODER withCompletionBlock:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:(error == nil ? @"已保存到相册" : @"保存失败") delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            if(error){
                [_playerControlDelegate UpdateSnapShot:YES];
            }else{
                [_playerControlDelegate UpdateSnapShot:NO];
            }
            
        }withIdentifierBlock:^(id identifier){
            [_playerControlDelegate saveMediaFile:identifier withTime:date withPlayerCmd:SnapShot];
        }
         
         
         ];
    }else{
        [_playerControlDelegate UpdateSnapShot:NO];
    }
    
    
    
}


-(void)controlPtz:(NSString*)cameraId cmd:(int)cmd  isStart:(BOOL)isStart
{
    JPlayer_PtzRequest request;
    
    strcpy(request.m_id,[cameraId UTF8String]);
    request.m_cmd = cmd;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL isHave = [userDefaultes boolForKey:@"yunjing"];
    if (isHave) {
        NSString *rank = [userDefaultes valueForKey:@"yunjingRank"];
        if ([rank isEqualToString:@"1"]) {
            request.m_speed = 10;
        } else if ([rank isEqualToString:@"2"]) {
            request.m_speed = 15;
        } else if ([rank isEqualToString:@"3"]) {
            request.m_speed = 19;
        } else if ([rank isEqualToString:@"4"]) {
            request.m_speed = 28;
        } else if ([rank isEqualToString:@"5"]) {
            request.m_speed = 37;
        } else if ([rank isEqualToString:@"6"]) {
            request.m_speed = 46;
        } else if ([rank isEqualToString:@"7"]) {
            request.m_speed = 55;
        } else if ([rank isEqualToString:@"8"]) {
            request.m_speed = 64;
        }
    } else {
        request.m_speed = 37;
    }
    request.m_data = isStart ? JPLAYER_PTZ_CMD_START : JPLAYER_PTZ_CMD_STOP;
    
    
    NVS_JPlayer_ControlPtz(request);
}


-(void)playSound
{
    NVS_JPlayer_PlaySound(mPlayerId);
}

-(void)stopSound
{
    NVS_JPlayer_StopSound(mPlayerId);
}

//#pragma mark - PlayerControlDelegate
//-(void)UpdateCmdResult:(NSString *)msg playercmd:(PlayerCmd)playercmd
//{
//
//}
//
//-(void)UpdateSnapShot:(id)mediaFiles
//{
//
//}
//
//-(void)UpdateQualityMode:(int)resolution
//{
//
//}
//
//-(void)UpdateFlow:(int)download vfps:(int)vfps
//{
//
//}
//
//-(void)UpdateFrameRate:(int)upward download:(int)download
//{
//
//}
//
//-(void)UpdatePlaytime:(long)timestamp
//{
//
//}
//
//-(void)UpdateRecordStatus:(BOOL)isOpen msg:(NSString *)msg
//{
//
//}
//
//-(void)UpdateRecordTime:(long)time
//{
//
//}
//
//-(void)StreamBraked
//{
//
//}

@end
