//
//  XRPhtoManager.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XRPhotoAlbumModel;
@class XRPhotoAssetModel;
@class PHCachingImageManager;
@interface XRPhtoManager : NSObject

/// 需要进行caching处理，目前没有进行caching处理。
@property (nonatomic, strong) PHCachingImageManager * cacheImageManager;
@property (nonatomic, strong) NSOperationQueue * requestQueue;
@property (nonatomic, assign) BOOL isAscingForCreation; // 是否按照创建日期进行升序排序 默认YES

+ (instancetype)manager;

@property (nonatomic, assign) BOOL authorizationStatusAuthrized; // 是否已经授权验证了

/** 获取相机相册列表
 
 @param allowPickVideo 是否选择视频
 
 @param targetSize 指定返回的图片的尺寸
 
 @param fetchedAlbumListBlock 返回相册回调
 */
- (void)getSmartPhotoAlbumListWithAllowPickVideo:(BOOL)allowPickVideo
                                      targetSize:(CGSize)targetSize
                                fetchedAlbumList:(void (^)(NSArray <XRPhotoAlbumModel *>* albumList))fetchedAlbumListBlock;

/** 获取所有的相册列表
 
 @param allowPickVideo 是否选择视频
 
 @param targetSize 指定返回的图片的尺寸
 
 @param fetchedAlbumListBlock 返回相册回调
 */
- (void)getAllPhotoAlbumListWithAllowPickVideo:(BOOL)allowPickVideo
                                    targetSize:(CGSize)targetSize
                              fetchedAlbumList:(void (^)(NSArray<XRPhotoAlbumModel *> *albumList))fetchedAlbumListBlock;

/** 获取缩略图
 
 @param phModel 资源模型
 
 @param targetSize 需要的图片尺寸，请勿*UIScreen的scale
 
 @param completeBlock 获取图片的回调
 */
- (void)getThumbImageWithAsset:(XRPhotoAssetModel *)phModel
                    targetSize:(CGSize)targetSize
                 completeBlock:(void (^)(BOOL isDegrade, UIImage * image))completeBlock;

/** 获取原图
 
 @param phModel 资源模型
 
 @param completeBlock 获取图片的回调
 */
- (void)getOriginalImageWithAsset:(XRPhotoAssetModel *)phModel completeBlock:(void (^)(UIImage * image))completeBlock;

@end


/** Exmaple
 
 XRImagePickerController * pickerCtrl = [[XRImagePickerController alloc] init];
 pickerCtrl.pickerDelegate = self;
 [self presentViewController:pickerCtrl animated:YES completion:nil];
 
 */
