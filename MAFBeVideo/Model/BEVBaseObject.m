//
//  BEVBaseObject.m
//  BEVideo
//
//  Created by FM on 15/12/17.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "BEVBaseObject.h"

@implementation BEVBaseObject

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}

- (instancetype)initWithTBXMLElement:(TBXMLElement*)element {
    NSAssert(false, @"Over ride in TBXML subclasses");
    return nil;
}

@end
