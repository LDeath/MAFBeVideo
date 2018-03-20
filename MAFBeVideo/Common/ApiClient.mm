//
//  ApiClient.m
//  BEVideo
//
//  Created by FM on 15/12/28.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "ApiClient.h"
#include "NvsJPlayerSDK.h"
#import "CameraNode.h"
#import "CacheSingleton.h"
#import "AppConfig.h"
#import "PlayControl.h"

#define CONVERT_CHAR_TO_STRING(c) [NSString stringWithUTF8String:c]
#define CONVERT_INT_TO_STRING(number) [[NSString alloc] initWithFormat:@"%d",number]

@implementation ApiClient

+(void)logout:(void (^)(BOOL, NSString *))logoutCallback
{
    AsyncTaks_Excute(^{
      LONG result = NVS_JPlayer_Logout();
        onUIThread(^{
            if(result == 0){
                logoutCallback(YES,nil);
            }else{
                logoutCallback(NO,[self getErrorCode:result]);
            }
        });
    });
}

+(NSString *)creatCacheKey:(NSString *)resId page:(NSInteger)index
{
    return [NSString stringWithFormat:@"reqeust-cameraDir-url-resId=%@-page=%d",resId,(int)index];
}

+(void)loginPlayerVisit:(void (^)(BOOL, NSString *))onResult
{
    
    [self loginPlayer:[AppConfig getVisitAccount] password:[AppConfig getVisitAccount] onResult:onResult];
}



+(void)loginPlayer:(NSString *)name password:(NSString *)password onResult:(void (^)(BOOL, NSString *))onResult
{
    
    AsyncTaks_Excute(^{
        
        long ok = [[PlayControl getInstance] login:name password:password host:[AppConfig getIpHost] port:[AppConfig getIpPort]];
        
        //登陆成功  清除缓存
        if(ok == 0){
            [[CacheSingleton getInstance] removeAllObjects];
        }
        
        if(onResult != nil){
            onUIThread(^{
                onResult((ok == 0),[self getErrorCode:ok]);
            });
        }

    });

    
}

+(void)getCameraDirResId:(NSString *)resId page:(NSInteger)index  cacheEnable:(BOOL)useCache success:(success)successBlock fail:(void (^)(NSString *))failBlock
{
    
    if(resId == nil)
        resId = @"";
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      dispatch_async(dispatch_queue_create("updateCameraDir", DISPATCH_QUEUE_SERIAL), ^{
    
          
        NSMutableArray *camerArray;
        YYMemoryCache *cache;
        NSString *cacheKey;
          
        if(useCache){
            cacheKey = [self creatCacheKey:resId page:index];
              
            cache = [CacheSingleton getInstance];
              
            camerArray = [cache objectForKey:cacheKey];
            
            if(camerArray != nil && camerArray.count > 0){
                onUIThread(^{
                    Lg(@"find cache for %@",cacheKey);
                    successBlock(camerArray);
                });
                return ;
            }
        }
          
        Lg(@"request camerDir for resId=%@ page=%d",resId,index);
        
        JPlayer_ResourceRequest request;
        strcpy(request.m_id, [resId UTF8String]);
        request.m_pageNum = (int)index;
        
        JPlayer_ResourceResponse response;
        JPlayer_ResourceItem resourceItem[10];
        response.m_pItems = resourceItem;
        response.m_itemCount = 10;
        
        long errorCode = NVS_JPlayer_QuerySubResource(&request,&response);
        
//        Lg(@"errorCode %ld count=%d",errorCode,response.m_itemCount);

        if(camerArray == nil)
            camerArray = [[NSMutableArray alloc]init];
                
        for(int i = 0; i < response.m_itemCount;i++){
            CameraNode *node = [[CameraNode alloc]init];
            JPlayer_ResourceItem item = response.m_pItems[i];
            
            node.nodeId = CONVERT_CHAR_TO_STRING(item.m_id);
            node.serverId = CONVERT_CHAR_TO_STRING(item.m_serverId);
            node.encoderId = CONVERT_CHAR_TO_STRING(item.m_encoderId);
            node.parentId = CONVERT_CHAR_TO_STRING(item.m_parentId);
            node.name = CONVERT_CHAR_TO_STRING(item.m_name);
            node.type = CONVERT_INT_TO_STRING(item.m_type);
            node.status = CONVERT_INT_TO_STRING(item.m_status);
            node.userRight = CONVERT_INT_TO_STRING(item.m_userRight);
            
            [camerArray addObject:node];
        }
          
        if(useCache)
        {
            [cache setObject:camerArray forKey:cacheKey];
            Lg(@"update cache whitch %@ for %@",((camerArray != nil && camerArray.count > 0) ? @" is not nil" : @"is nil"),cacheKey)
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            if(errorCode == 0 && successBlock != nil){
                successBlock(camerArray);
            }else if(failBlock != nil){
                failBlock([self getErrorCode:errorCode]);
            }
        });

    
    });
}

+(NSString *)getErrorCode:(long)code
{
    NSString *errorCode;
    switch (code) {
        case JPLAYER_MSG_NO_INIT_FAIL:
            errorCode = @"初始化失败";
            break;
         
        case JPLAYER_MSG_ERROR:
            errorCode = @"操作失败";
            break;
            
        case JPLAYER_MSG_LOGIN_CONNECT_FAIL:
            errorCode = @"连接服务器失败";
            break;
            
        case JPLAYER_MSG_LOGIN_PASS_ERROR:
            errorCode = @"密码错误";
            break;
            
        case JPLAYER_MSG_LOGIN_REFUSE:
            errorCode = @"登陆被拒绝";
            break;
            
    }
    
    return errorCode;
}

@end
