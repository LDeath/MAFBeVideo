//
//  util.h
//  BEVideo
//
//  Created by FM on 15/12/17.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#ifndef util_h
#define util_h

#define BARBUTTON(TITLE,SELECTOR) [[UIBarButtonItem alloc] \
initWithTitle:TITLE style:UIBarButtonItemStylePlain \
target:self action:SELECTOR]

#pragma mark - 布局
#pragma mark -- 水平居中
#define HorizontalCenter(view,parentView)  \
[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]

#pragma mark -- 竖直居中
#define VerticalCenter(view,parentView)  \
[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]

#pragma mark --设置宽度
#define setWidth(view,parentView,width) \
[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeWidth multiplier:0 constant:width]

#pragma mark --高度
#define setHeight(view,parentView,width) \
[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeHeight multiplier:0 constant:width]

#define setWidthMultiplier(view,parentView,multi) \
[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeWidth multiplier:multi constant:0]

#define setHeightMultiplier(view,parentView,multi) \
[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeHeight multiplier:multi constant:0]



#pragma mark - tabview config
#define kCommonTablePageSize 10

#define kCommonBGColor RGBACOLOR(250,250,250,1)

//#define kCommonFooterBgColor RGBACOLOR(235.0,235.0,243.0,1)
#define kCommonFooterBgColor [UIColor whiteColor]
#define kCommonFooterTvColor [UIColor blackColor];

#define kCommonFooterHeight 44

#define kCommonSeparatorColor RGBACOLOR(217.0,217.0,223.0,1)

#define kCommonSelectCellColor RGBACOLOR(203.0,203.0,203.0,1)

#pragma mark - video config
//视频播放页面 video下面的背景
#define kVideoOptionMuteBGColor RGBACOLOR(251.0,251.0,251.0,1.0)
#define kVideoOptionBGColor RGBACOLOR(244.0,245.0,246.0,1.0)


#endif /* util_h */
