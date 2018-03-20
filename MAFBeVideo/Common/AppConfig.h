//
//  AppConfig.h
//  BEVideo
//
//  Created by FM on 15/12/29.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

//获取游客登陆时的账号
+(NSString *)getVisitAccount;

///保存用户信息
+(void)saveUserMsg:(NSString *)username password:(NSString *)pwd;

///清除用户信息
+(void)clearUserMsg;

///用的是否已经登陆
+(BOOL)hasLogin;

///获取用户账号
+(NSString *)getUserName;

///用户密码
+(NSString *)getUserPassWord;



#pragma mark - 网络配置
+(void)saveIpConfig:(NSString *)ip port:(NSString *)port;

///获取ip
+(NSString *) getIpHost;

///获取端口号
+(NSString *)getIpPort;

#pragma mark - 播放设置
///设置是否是实时优先
+(void)setPlayMode:(BOOL)isLiuChang;
///返回是否是实时优先
+(BOOL)getPlayMode;

///子码流
+(void)setStreamMode:(BOOL)isSubCode;
+(BOOL)getStreamMode;

///声音
+ (void)setVoiceMode:(BOOL)isVoice;
+ (BOOL)getVoiceMode;

///分享直播模式
+(void)setShareMode:(int)shareMode;
+(BOOL)getShareMode;


///设置目录树树浏览方式
+(void)setNodeMode:(BOOL)isModeText;
+(BOOL)getNodeMode;

@end
