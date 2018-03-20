//
//  KVideoOptionView.h
//  BEVideo
//
//  Created by FM on 15/12/19.
//  Copyright © 2015年 BlueEye. All rights reserved.
//
// 录音 截图 对讲操作
#import <UIKit/UIKit.h>

@protocol KVideoOptionPortDelegate <NSObject>

-(void)onRecord;
-(void)onSnap;
-(void)onAudio;

@end

@interface KVideoOptionPortView : UIView
@property(nonatomic, weak) id<KVideoOptionPortDelegate>delegate;
@end
