//
//  CacheSingleton.m
//  BEVideo
//
//  Created by FM on 15/12/18.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "CacheSingleton.h"

@interface CacheSingleton()


@end

static NSMutableDictionary *map;

@implementation CacheSingleton

+(id)getInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        map = [NSMutableDictionary dictionary];
        return [[self alloc] init];
    });
}

-(BOOL)containKey:(NSString *)key
{
    return [map objectForKey:key] != nil;
}

-(void)putObject:(id)value Key:(NSString *)key
{
    [map setObject:value forKey:key];
}

-(id)getObjectForKey:(NSString *)key
{
    return [map objectForKey:key];
}

-(void)clear
{
    [map removeAllObjects];
}

@end
