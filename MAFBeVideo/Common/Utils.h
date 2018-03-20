//
//  Utils.h
//  BEVideo
//
//  Created by FM on 15/12/18.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MBProgressHUD;

@interface Utils : NSObject

+ (UIImage*) createImageWithColor: (UIColor*) color;

+(MBProgressHUD *)createHUD;

+(void)setUpNavigationBarAppearance;

@end

