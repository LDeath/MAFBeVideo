//
//  KGLVideoControl.h
//  BEVideo
//
//  Created by FM on 15/12/25.
//  Copyright © 2015年 BlueEye. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "CameraNode.h"
/**
 
 
 
 **/

@interface KGLVideoControl : GLKViewController<GLKViewDelegate>

@property float scal;
@property (nonatomic,strong) UIPanGestureRecognizer * pan;
@property (nonatomic) NSUInteger numTouches;
@property (nonatomic,strong) UIPinchGestureRecognizer * pinch;
@property (nonatomic) int extra;
@property  BOOL canGesture;


-(instancetype)initWithCameraNode:(CameraNode *)cameraNode;

///显示loading 和 loading下面的提示文字
-(void)showIndicatorViewWith:(BOOL)show text:(NSString *)text;

-(void)updateRecordTime:(long)time;

-(void)hideRecordTime;

-(void)showRecordTime;

@end
