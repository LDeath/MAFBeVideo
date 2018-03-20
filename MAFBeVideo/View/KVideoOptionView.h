//
//  KVideoOptionView.h
//  BEVideo
//
//  Created by FM on 15/12/22.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum TouchOptionType{
    TouchEventSetting = 0,
    TouchEventOptionPort,
    
}TouchOptionType;

typedef void(^OnClickListener)(TouchOptionType Type);


@interface KVideoOptionView : UIView

@property(copy) OnClickListener onClickListener;

-(void)updateTime:(NSString *)time;

@end
