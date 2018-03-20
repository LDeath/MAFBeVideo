//
//  KVideoCloudView.m
//  BEVideo
//
//  Created by FM on 15/12/19.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "KVideoCloudView.h"
#import "ZAShapeButton.h"
#import "PlayControl.h"
#import "Masonry.h"

#define TitleFocus @"焦距"
#define TitleZoom @"焦点"

@interface KVideoCloudView()

/**
 焦距按钮
 */
@property (nonatomic,strong) ZAShapeButton *focusBtn;
/**
 方向按钮
 */
@property (nonatomic,strong) ZAShapeButton *circleBtn;
/**
 焦点按钮
 */
@property (nonatomic,strong) ZAShapeButton *zoomBtn;

@end

@implementation KVideoCloudView
#pragma mark 懒加载
/**
 焦距按钮
 */
- (ZAShapeButton *)focusBtn {
    if (_focusBtn == nil) {
        _focusBtn = [[ZAShapeButton alloc] initWithFrame:CGRectMake(0, 0, 60, 150) ButtonType:3];
        _focusBtn.tag = 1;
        [_focusBtn setTitle:TitleFocus];
        [_focusBtn addTarget:self action:@selector(buttonUpSide:) forResponseState:ButtonClickType_TouchUpInside];
        [_focusBtn addTarget:self action:@selector(longPressButtonClick:) forResponseState:ButtonClickType_TouchDownPress];
    }
    return _focusBtn;
}
/**
 方向按钮
 */
- (ZAShapeButton *)circleBtn {
    if (_circleBtn == nil) {
        _circleBtn = [[ZAShapeButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150) ButtonType:0];
        _circleBtn.tag = 0;
        [_circleBtn addTarget:self action:@selector(buttonUpSide:) forResponseState:ButtonClickType_TouchUpInside];
        [_circleBtn addTarget:self action:@selector(longPressButtonClick:) forResponseState:ButtonClickType_TouchDownPress];
    }
    return _circleBtn;
}
/**
 焦点按钮
 */
- (ZAShapeButton *)zoomBtn {
    if (_zoomBtn == nil) {
        _zoomBtn = [[ZAShapeButton alloc] initWithFrame:CGRectMake(0, 0, 60, 150) ButtonType:3];
        _zoomBtn.tag = 2;
        [_zoomBtn addTarget:self action:@selector(buttonUpSide:) forResponseState:ButtonClickType_TouchUpInside];
        [_zoomBtn addTarget:self action:@selector(longPressButtonClick:) forResponseState:ButtonClickType_TouchDownPress];
        [_zoomBtn setTitle:TitleZoom];
    }
    return _zoomBtn;
}
#pragma mark 初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self initViews];
        [self setupLayout];
    }
    return self;
}
#pragma mark customFunction
- (void)initViews {
    [self addSubview:self.focusBtn];
    [self addSubview:self.circleBtn];
    [self addSubview:self.zoomBtn]; 
}

-(void)setupLayout
{
    CGFloat space = (self.width - 60 - 60 - 150) / 4.0;
//    space = 25;
    [self.circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(space);
        make.centerY.equalTo(self);
        make.height.equalTo(@150);
    }];
    
    
    [self.zoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-space);
        make.centerY.equalTo(self);
        make.height.equalTo(@150);
    }];
    self.circleBtn.titleLabel.size = self.circleBtn.size;
    self.focusBtn.titleLabel.size = self.focusBtn.size;
    self.zoomBtn.titleLabel.size = self.zoomBtn.size;
}

#pragma mark -  按钮单击事件
//上下左右  抬起事件
-(void)buttonUpSide:(ZAShapeButton *)button
{
    int CMD = [self getSelectPartCmd:button];
    
    Lg(@"--- 停止操作 ----");
    
    AsyncTaks_Excute(^{
        [[PlayControl getInstance] controlPtz:_camerId cmd:CMD isStart:(NO)];
    });
}


#pragma mark -  按钮长按事件
-(void)longPressButtonClick:(ZAShapeButton *)button
{

    Lg(@"--- 开始操作 ----");

    
    int CMD = [self getSelectPartCmd:button];
    AsyncTaks_Excute(^{
        [[PlayControl getInstance] controlPtz:_camerId cmd:CMD isStart:(YES)];
    });

}


#pragma mark - 获取选中位置
-(int)getSelectPartCmd:(ZAShapeButton *)button
{
    NSString *partString;
    int cmd = -1;
    
    /*
     
     JPLAYER_PTZ_CMD_ZOOM_IN = 14,
     JPLAYER_PTZ_CMD_ZOOM_OUT = 16,
     
     JPLAYER_PTZ_CMD_FOCUS_IN = 18,
     JPLAYER_PTZ_CMD_FOCUS_OUT = 20,
     */
    
    switch (button.selectButtonPosition) {
        case SelectButtonPosition_Top:
            
            if(button.tag == 0){
                cmd = 8;
                partString = @"向上";
            }else if(button.tag == 1)
            {
                cmd = 14;
                partString = @"焦距放大";
            }else if(button.tag == 2)
            {
                cmd = 18;
                partString = @"焦点放大";
            }
            
            break;
        case SelectButtonPosition_Buttom:
            
            if(button.tag == 0){
                cmd = 6;
                partString = @"向下";

            }else if(button.tag == 1)
            {
                partString = @"焦距缩小";
                cmd = 16;
            }else if(button.tag == 2)
            {
                partString = @"焦点缩小";
                cmd = 20;
            }

            
            break;
        case SelectButtonPosition_Center:
            partString=@"中";
            
            break;
        case SelectButtonPosition_Left:
            partString=@"左";
            cmd = 4;
            break;
        case SelectButtonPosition_Right:
            partString=@"右";
            cmd = 2;
            break;
        default:
            break;
    }
    
    return cmd;
    
    
}

@end
