//
//  BEVBaseObject.h
//  BEVideo
//
//  Created by FM on 15/12/17.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ono.h>
#import <TBXML.h>

@interface BEVBaseObject : NSObject
- (instancetype)initWithXML:(ONOXMLElement *)xml;

- (instancetype)initWithTBXMLElement:(TBXMLElement*)element;
@end
