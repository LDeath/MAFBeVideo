//
//  CacheSingleton.h
//  BEVideo
//
//  Created by FM on 15/12/18.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMemoryCache.h"


@interface CacheSingleton : YYMemoryCache

+(id)getInstance;

//-(BOOL)containKey:(NSString *)key;
//
//
//-(void)putObject:(id)value Key:(NSString *)key;
//
//-(id)getObjectForKey:(NSString *)key;
//
//-(void)clear;

@end
