//
//  CameraNode.h
//  BEVideo
//
//  Created by FM on 15/12/17.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEVBaseObject.h"

@interface CameraNode : BEVBaseObject

@property (nonatomic, copy) NSString *nodeId;
@property (nonatomic, copy) NSString *serverId;
@property (nonatomic,copy) NSString *encoderId;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;//1目录  2摄像头
@property (nonatomic,copy) NSString *status; // 0 离线  1 在线
@property (nonatomic,copy) NSString *userRight;

#pragma mark - 判断当前节点是否是目录
-(BOOL)isDir;

-(BOOL)isOnline;

@end
