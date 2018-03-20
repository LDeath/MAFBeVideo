//
//  MutiButton.h
//  BEVideo
//
//  Created by FM on 15/12/23.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ModeType{
    Mode1 = 1,
    Mode2 = 2,
}ModeType;

@interface MutiButton : UIButton

@property(nonatomic) ModeType currentModeType;

-(void)setupMutiImage:(ModeType)type normal:(NSString *)normalImage pressed:(NSString *)pressedImage disable:(NSString *)disableImage;

-(void)setMode:(ModeType)type;

@end
