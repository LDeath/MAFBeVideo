//
//  AppConfig.m
//  BEVideo
//
//  Created by FM on 15/12/29.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "AppConfig.h"

#define KEY_USERNAME @"username"
#define KEY_USERPWD @"userPwd"

#define KEY_IP_HOST @"ipHost"
#define KEY_IP_PORT @"ipPort"

///播放模式
#define KEY_MODE_PLAY @"mode_play"
#define KEY_MODE_STAREM @"mode_stream"
#define KEY_MODE_VOICE @"mode_voice"
#define KEY_MODE_SHARE @"mode_share_live"
//目录树预览方式
#define KEY_MODE_NODELIST @"mode_node_list"

@implementation AppConfig


+(NSString *)getVisitAccount
{
    return [NSString stringWithFormat:@"lskj_everybody_%ld",(long)[[NSDate date] timeIntervalSince1970]];
}

+(void)saveUserMsg:(NSString *)username password:(NSString *)pwd
{
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username forKey:KEY_USERNAME];
    [userDefaults setObject:pwd forKey:KEY_USERPWD];
    [userDefaults synchronize];
}

+(void)clearUserMsg
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:KEY_USERNAME];
    [userDefaults removeObjectForKey:KEY_USERPWD];
    
    [userDefaults synchronize];
}

+(NSString *)getUserName
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes stringForKey:KEY_USERNAME];
}

+(NSString *)getUserPassWord
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes stringForKey:KEY_USERPWD];
}



+(void)saveIpConfig:(NSString *)ip port:(NSString *)port
{
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:ip forKey:KEY_IP_HOST];
    [userDefaults setObject:port forKey:KEY_IP_PORT];
    [userDefaults synchronize];
}

+(NSString *)getIpHost
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *ipHost = [userDefaultes stringForKey:KEY_IP_HOST];
    
    if(!ipHost)
        return NET_HOST;
    return ipHost;
}

+(NSString *)getIpPort
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *ipPort =  [userDefaultes stringForKey:NET_HOST_PORT];
    if(!ipPort){
        return NET_HOST_PORT;
    }
    return ipPort;
}

+(void)setPlayMode:(BOOL)isShishi
{
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isShishi forKey:KEY_MODE_PLAY];
    [userDefaults synchronize];
}

+(BOOL)getPlayMode
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes boolForKey:KEY_MODE_PLAY];
}

///子码流
+(void)setStreamMode:(BOOL)isSubCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isSubCode forKey:KEY_MODE_STAREM];
    [userDefaults synchronize];
}

///是否是子码流
+(BOOL)getStreamMode
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes boolForKey:KEY_MODE_STAREM];
}
///声音
+ (void)setVoiceMode:(BOOL)isVoice {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isVoice forKey:KEY_MODE_VOICE];
    [userDefaults synchronize];
}
///是否开启声音
+ (BOOL)getVoiceMode {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes boolForKey:KEY_MODE_VOICE];
}


#pragma mark - 设置目录树预览模式
+(void)setNodeMode:(BOOL)isModeImage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isModeImage forKey:KEY_MODE_NODELIST];
    [userDefaults synchronize];
}

#pragma mark - 获取目录树预览方式  
///  false--文字模式  true--图片模式
+(BOOL)getNodeMode
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes boolForKey:KEY_MODE_NODELIST];
}

@end
