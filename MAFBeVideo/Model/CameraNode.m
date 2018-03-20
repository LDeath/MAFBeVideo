//
//  CameraNode.m
//  BEVideo
//
//  Created by FM on 15/12/17.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "CameraNode.h"

static NSString * const kNodeId = @"id";
static NSString * const kServerId = @"serverId";
static NSString * const kEncoderId = @"encoderId";
static NSString * const kParentId = @"parentId";
static NSString * const kName = @"name";
static NSString * const kType = @"type";
static NSString * const kStatus = @"status";
static NSString * const kUserRight = @"userRight";

@implementation CameraNode

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _nodeId = [[xml firstChildWithTag:kNodeId] stringValue];
        _serverId = [[xml firstChildWithTag:kServerId] stringValue];
        _encoderId = [[xml firstChildWithTag:kEncoderId] stringValue];
        _parentId = [[xml firstChildWithTag:kParentId] stringValue];
        _name = [[xml firstChildWithTag:kName] stringValue];
        _type = [[xml firstChildWithTag:kType] stringValue];
        _status = [[xml firstChildWithTag:kStatus] stringValue];
        _userRight = [[xml firstChildWithTag:kStatus] stringValue];
    }
    
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"nodeid = %@ serverId=%@ encoderId=%@ name=%@ type=%@ status=%@",_nodeId,_serverId,_encoderId,_name,_type,_status];
}


-(BOOL)isDir
{
    if(self.type == nil)
        return NO;
    if([@"1" isEqualToString:self.type])
        return YES;
    return NO;
}

-(BOOL)isOnline
{
    return [@"1" isEqualToString:_status];
}

@end
