//
//  KVideoOptionView.m
//  BEVideo
//
//  Created by FM on 15/12/22.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "KVideoOptionView.h"
#import "Utils.h"
#import "PlayControl.h"
#import "Masonry.h"

#define kButtonHighlightColor RGBACOLOR(40.0, 174.0, 254.0, 1.0)
#define kLineViewColor RGBACOLOR(207.0, 208.0, 208.0, 1.0)

@interface KVideoOptionView()

//@property (nonatomic, strong) UIButton *muteLayout;
//@property (nonatomic, strong) UIImageView *muteImgV;
/**
 设置按钮
 */
@property (nonatomic, strong) UIButton *settingBtn;
/**
 线1
 */
@property (nonatomic, strong) UIView *lineV1;
/**
 时间label
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 线2
 */
@property (nonatomic, strong) UIView *lineV2;
/**
 云镜/操作按钮
 */
@property (nonatomic, strong) UIButton *controlBtn;

@end

@implementation KVideoOptionView

#pragma 懒加载
- (UIButton *)settingBtn {
    if (_settingBtn == nil) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //正常状态
        [_settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_settingBtn setBackgroundImage:nil forState:UIControlStateNormal];
        
        //选中状态
        [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_settingBtn setBackgroundImage:[Utils createImageWithColor:kButtonHighlightColor] forState:UIControlStateHighlighted];
        
        _settingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_settingBtn addTarget:self action:@selector(clickSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}
- (UIView *)lineV1 {
    if (_lineV1 == nil) {
        _lineV1 = [[UIView alloc] init];
        _lineV1.backgroundColor = kLineViewColor;
    }
    return _lineV1;
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
- (UIView *)lineV2 {
    if (_lineV2 == nil) {
        _lineV2 = [[UIView alloc] init];
        _lineV2.backgroundColor = kLineViewColor;
    }
    return _lineV2;
}
/**
 云镜/操作按钮
 */
- (UIButton *)controlBtn {
    if (_controlBtn == nil) {
        _controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //正常状态
        [_controlBtn setTitle:@"云镜" forState:UIControlStateNormal];
        [_controlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_controlBtn setBackgroundImage:nil forState:UIControlStateNormal];
        
        //选中状态
        [_controlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_controlBtn setBackgroundImage:[Utils createImageWithColor:kButtonHighlightColor] forState:UIControlStateHighlighted];
        
        _controlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_controlBtn addTarget:self action:@selector(toggleOptionPortView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlBtn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self initViews];
        [self setupLayout];
    }
    return self;
}
-(void)initViews
{
    [self addSubview:self.settingBtn];
    [self addSubview:self.lineV1];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineV2];
    [self addSubview:self.controlBtn];
}
-(void)setupLayout
{
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.and.height.mas_equalTo(self.height);
    }];
    [self.lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingBtn.mas_right);
        make.top.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(@1);
    }];
    [self.controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(self);
        make.width.and.height.mas_equalTo(self.height);
    }];
    [self.lineV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self.controlBtn.mas_left);
        make.height.equalTo(self);
        make.width.equalTo(@1);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.equalTo(self);
        make.left.equalTo(self.lineV1.mas_right);
        make.right.equalTo(self.lineV2.mas_left);
    }];
}
-(void)updateTime:(NSString *)time
{
    
    [self.timeLabel setText:time];
}
/**
 设置点击事件
 */
- (void)clickSettingBtn {
    if (self.onClickListener) {
        self.onClickListener(TouchEventSetting);
    }
}
/**
 云镜/操作 点击事件
 */
-(void)toggleOptionPortView
{
//    if(self.controlBtn.tag != 1){
//        [self.controlBtn setTitle:@"操作" forState:UIControlStateNormal];
//        self.controlBtn.tag = 1;
//    }else{
//        [self.controlBtn setTitle:@"云镜" forState:UIControlStateNormal];
//        self.controlBtn.tag = 2;
//    }
//    if(self.onClickListener){
//        self.onClickListener(TouchEventOptionPort);
//    }
}
@end
