//
//  ApiClient.h
//  BEVideo
//
//  Created by FM on 15/12/28.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^success)(NSMutableArray *data);

@class CameraNode;

@interface ApiClient : NSObject

+(void)logout:(void (^)(BOOL success,NSString *errorMsg)) logoutCallback;

///创建目录树缓存key
+(NSString *)creatCacheKey:(NSString *)resId page:(NSInteger)index;

///登陆Player
+(void)loginPlayer:(NSString *)name  password:(NSString *)password onResult : (void (^)(BOOL success,NSString *errorMsg))onResult;

///游客登陆
+(void)loginPlayerVisit:(void (^)(BOOL success,NSString *errorMsg))onResult;


///获取目录树
+(void)getCameraDirResId: (NSString *)resId page : (NSInteger)index cacheEnable:(BOOL)useCache success:(success)successBlock fail:(void (^)(NSString *errorMsg)) failBlock;

@end
