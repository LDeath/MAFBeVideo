//
//  KVideoOptionView.m
//  BEVideo
//
//  Created by FM on 15/12/19.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "KVideoOptionPortView.h"
#import "ZAShapeButton.h"
#import "MutiButton.h"
#import "Masonry.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface KVideoOptionPortView()<UIAlertViewDelegate>
/**
 录像按钮
 */
@property (nonatomic,strong) MutiButton *recordBtn;
/**
 按住说话
 */
@property (nonatomic,strong) MutiButton *audioBtn;
/**
 截屏按钮
 */
@property (nonatomic,strong) MutiButton *snapBtn;

@end

@implementation KVideoOptionPortView
#pragma mark 懒加载
/**
 录像按钮
 */
- (MutiButton *)recordBtn {
    if (_recordBtn == nil) {
        _recordBtn = [[MutiButton alloc] init];
        [_recordBtn setupMutiImage:Mode1 normal:@"video_record_normal" pressed:@"video_record_pressed" disable:nil];
        [_recordBtn setupMutiImage:Mode2 normal:@"video_record_ing_normal" pressed:@"video_record_ing_pressed" disable:nil];
        [_recordBtn addTarget:self action:@selector(onBtnRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}
/**
 按住说话
 */
- (MutiButton *)audioBtn {
    if (_audioBtn == nil) {
        _audioBtn = [[MutiButton alloc] init];
        [_audioBtn setupMutiImage:Mode1 normal:@"video_audio_normal" pressed:@"video_audio_normal" disable:nil];
        [_audioBtn addTarget:self action:@selector(onBtnAudio) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioBtn;
}
/**
 截屏按钮
 */
- (MutiButton *)snapBtn {
    if (_snapBtn == nil) {
        _snapBtn = [[MutiButton alloc] init];
        [_snapBtn setupMutiImage:Mode1 normal:@"video_snap_noraml" pressed:@"video_snap_pressed" disable:nil];
        [_snapBtn addTarget:self action:@selector(onBtnSnap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapBtn;
}
#pragma mark 初始化
-(id)init
{
    if(self = [super init]){
        [self initViews];
        [self setupLayout];
    }
    return self;
}
#pragma mark customFunction
-(void)initViews
{
    [self addSubview:self.recordBtn];
    [self addSubview:self.audioBtn];
    [self addSubview:self.snapBtn];
}
-(void)onBtnSnap
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusDenied || author == kCLAuthorizationStatusRestricted) {
        UIAlertView * positioningAlertivew = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"截屏需要访问相册,为了更好的体验,请到设置->隐私->相册服务中开启相册服务,已便保存截屏信息!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启",nil];
        [positioningAlertivew show];    } else {
        Lg(@"---- 截图");
        if ([self.delegate respondsToSelector:@selector(onSnap)] && self.delegate) {
            [self.delegate onSnap];
        }
    }
//    typedef enum {
//        kCLAuthorizationStatusNotDetermined = 0, // 用户尚未做出选择这个应用程序的问候
//        kCLAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
//        kCLAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
//        kCLAuthorizationStatusAuthorized         // 用户已经授权应用访问照片数据} CLAuthorizationStatus;
//    }
}
-(void)onBtnRecord
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusDenied || author == kCLAuthorizationStatusRestricted) {
        //无权限 引导去开启
        UIAlertView * positioningAlertivew = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"录像需要访问相册,为了更好的体验,请到设置->隐私->相册服务中开启相册服务,已便保存录像信息!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启",nil];
        [positioningAlertivew show];
    } else {
        Lg(@"---- 录像");
        if ([self.delegate respondsToSelector:@selector(onRecord)] && self.delegate) {
            [self.delegate onRecord];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
-(void)onBtnAudio
{
    if ([self.delegate respondsToSelector:@selector(onAudio)] && self.delegate) {
        [self.delegate onAudio];
    }
}
-(void)setupLayout
{
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(RESIZE_WIDTH(170), RESIZE_HEIGHT(170)));
        make.left.equalTo(self).with.offset(15);
    }];
    
    [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(RESIZE_WIDTH(300), RESIZE_HEIGHT(300)));
        
    }];
    
    [self.snapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(RESIZE_WIDTH(170), RESIZE_HEIGHT(170)));
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

@end
