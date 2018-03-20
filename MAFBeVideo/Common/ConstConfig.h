//
//  AppConfig.h
//  BEVideo
//
//  Created by FM on 15/12/25.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#pragma 其他
#define UMENG_APP_KEY @"56a1eec3e0f55a763b001f83"


#pragma mark - 登陆相关
#define NET_HOST  @"116.255.198.211"
//#define NET_HOST  @"192.168.0.34"
#define NET_HOST_PORT @"11111"
//#define LOGIN_DEFAULT_NAME "admin"
//#define LOGIN_DEFAULT_PASSWORD "admin"

//默认摄像机 id
#define DEFAULT_CHANNELID "2100001201000005"


//
#define DEFAULT_FLODER  @"蓝视云"

//存储我的照片及视频的数据库表
#define DATABASE_RECORD @"record.db"
#define TABLE_NAME_RECORD @"media_record"

//抓图地址
#define Url_Capture(cameraId) \
[NSString stringWithFormat:@"http://demo.beyeon.com/device/channel!getSnapshot.do?channelId=%@",cameraId];

#endif /* AppConfig_h */
