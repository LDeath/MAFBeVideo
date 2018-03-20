//
//  ALAssetsLibrary+custom.h
//  BEVideo
//
//  Created by FM on 16/1/5.
//  Copyright © 2016年 BlueEye. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

typedef void(^SaveImageCompletion)(NSError* error);

///获取保存后图像的标识符
///@param identifier ios8.0及以上版本 返回 localIdentifier ios7及以下返回 NSURL
typedef void(^GetIdentifierBlock) (id identifier);

@interface ALAssetsLibrary (custom)

/**
 *  保存图片到指定相册  指定相册若不存在会自动创建相册
 *
 *  @param image           需要保存的图片
 *  @param albumName       相册名称
 *  @param completionBlock 完成后回调
 */
- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock withIdentifierBlock:(GetIdentifierBlock)identifierBlock;

@end
