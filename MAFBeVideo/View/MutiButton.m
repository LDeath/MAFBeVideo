//
//  MutiButton.m
//  BEVideo
//
//  Created by FM on 15/12/23.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "MutiButton.h"

@interface MutiButton()

@property(nonatomic) NSString *mode1Normal,*mode1Pressed,*mode1Disable;
@property(nonatomic) NSString *mode2Normal,*mode2Pressed,*mode2Disable;

@end

@implementation MutiButton

-(instancetype)init
{
    if(self = [super init]){
        _currentModeType = Mode1;
    }
    return self;
}

-(void)setupMutiImage:(ModeType)type normal:(NSString *)normalImage pressed:(NSString *)pressedImage disable:(NSString *)disableImage
{
    if(type == Mode1){
        _mode1Normal = normalImage;
        _mode1Pressed = pressedImage;
        _mode1Disable = disableImage;
        [self setImage:[UIImage imageNamed:_mode1Normal] forState:UIControlStateNormal];

    }else if(type == Mode2){
        _mode2Normal = normalImage;
        _mode2Pressed = pressedImage;
        _mode2Disable = disableImage;
//        [self setImage:[UIImage imageNamed:_mode2Normal] forState:UIControlStateNormal];
    }
}

-(void)setMode:(ModeType)type
{
    if(type == Mode1){
        [self setImage:[UIImage imageNamed:_mode1Normal] forState:UIControlStateNormal];
    }else if(type == Mode2){
        [self setImage:[UIImage imageNamed:_mode2Normal] forState:UIControlStateNormal];
    }
}

-(void)setEnabled:(BOOL)enabled
{
    Lg(@"--  setEnable %hhd",enabled);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(_currentModeType == Mode1){
        [self setImage:[UIImage imageNamed:_mode1Pressed] forState:UIControlStateHighlighted];
    }else if(_currentModeType == Mode2){
        [self setImage:[UIImage imageNamed:_mode2Pressed] forState:UIControlStateHighlighted];
    }
    
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(_currentModeType == Mode1){
        [self setImage:[UIImage imageNamed:_mode1Normal] forState:UIControlStateNormal];
    }else if(_currentModeType == Mode2){
        [self setImage:[UIImage imageNamed:_mode2Pressed] forState:UIControlStateNormal];
    }
    
    [super touchesEnded:touches withEvent:event];

}



@end
