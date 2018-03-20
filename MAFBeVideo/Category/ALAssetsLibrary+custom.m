//
//  ALAssetsLibrary+custom.m
//  BEVideo
//
//  Created by FM on 16/1/5.
//  Copyright © 2016年 BlueEye. All rights reserved.
//

#import "ALAssetsLibrary+custom.h"
#import <Photos/Photos.h>

@implementation ALAssetsLibrary (custom)

-(void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock withIdentifierBlock:(GetIdentifierBlock)identifierBlock
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [self photoKitSaveImage:image toAlbum:albumName withCompletionBlock:completionBlock withIdentifierBlock:identifierBlock];
    } else {
        //写入图片到相机胶卷
        [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                           completionBlock:^(NSURL* assetURL, NSError* error) {
                               
                               if (error) {
                                   completionBlock(error);
                                   return;
                               }
                               
                               identifierBlock([assetURL absoluteString]);
                               
                               //添加到指定相册
                               [self addAssetURL:assetURL toAlbum:albumName withCompletionBlock:completionBlock];
                           }];
    }
}


- (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    __block BOOL albumWasFound = NO;
    
    //搜索所有相册
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                            
                            //比较相册名称 查找指定相册
                            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                                
                                //目标相册被发现
                                albumWasFound = YES;
                                
                                //得到持有图片的asset实例
                                [self assetForURL: assetURL
                                      resultBlock:^(ALAsset *asset) {
                                          
                                          //添加图片到目标相册 ps：照片只会储存在相机胶卷里面，其余相册作为分类，只为方便查看，删除相册的照片不会影响这张照片的存在，删除相机胶卷照片会把照片删掉
                                          [group addAsset: asset];
                                          completionBlock(nil);
                                      }
                                     failureBlock:completionBlock];
                                
                                //目标相册找到，结束查找
                                return;
                            }
                            
                            if (group == nil && albumWasFound == NO) {
                                //目标相册不存在 创建相册
                                __weak ALAssetsLibrary* weakSelf = self;
                                
                                //创建新相册
                                [self addAssetsGroupAlbumWithName:albumName
                                                      resultBlock:^(ALAssetsGroup *group) {
                                                          //创建成功
                                                          //得到持有图片的asset实例
                                                          [weakSelf assetForURL: assetURL
                                                                    resultBlock:^(ALAsset *asset) {
                                                                        
                                                                        //添加图片到新建相册
                                                                        [group addAsset:asset];
                                                                        completionBlock(nil);
                                                                    }
                                                                   failureBlock:completionBlock];
                                                      }
                                                     failureBlock:completionBlock];
                                return;
                            }
                        }
                      failureBlock: completionBlock];
}


- (void)photoKitSaveImage:(UIImage *)image toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
    withIdentifierBlock:(GetIdentifierBlock)identifierBlock
{
    
    // 列出所有用户创建的相册
    PHFetchResult<PHCollection *> *fetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    __block PHAssetCollection *assetCollection = nil;
    __block NSString *localIdentifier = nil;
    [fetchResult enumerateObjectsUsingBlock:^(PHCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([collection.localizedTitle isEqualToString:albumName]) {
            assetCollection = (PHAssetCollection *)collection;
        }
    }];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHObjectPlaceholder *assetPlaceholder = createAssetRequest.placeholderForCreatedAsset;
        PHAssetCollectionChangeRequest *request;
        if (assetCollection) {
            request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else {
            request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
        }
        
        localIdentifier = assetPlaceholder.localIdentifier;
        
        [request addAssets:@[assetPlaceholder]];
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(error);
            if(success)
                identifierBlock(localIdentifier);
        });
    }];
}


@end
