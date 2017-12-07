//
//  XRImagePickerController.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRImagePickerController;
@class XRPhotoAlbumModel;
@class XRPhotoAssetModel;

@protocol XRImagePickerControllerDelegate <UINavigationControllerDelegate>

@optional

// 是否按照创建日期进行升序排序 默认YES
- (BOOL)xr_imagePickerControllerSortedByAscingCreation;

// 返回允许选择的最大资源数
- (NSInteger)xr_imagePickerControllerAllowMaxSelectCount;

// 选择资源数超出最大允许选择资源数时回调
- (void)xr_imagePickerControllerDidOverrunMaxAllowSelectCount:(XRImagePickerController *)picker;

// 点击取消
- (void)xr_imagePickerControllerDidCancel:(XRImagePickerController *)picker;

// 点击完成
- (void)xr_imagePickerControllerDidFinished:(XRImagePickerController *)picker didSelectAssets:(NSArray <XRPhotoAssetModel *> *)assets;

// 拍照完成后回调
- (void)xr_imagePickerControllerTakePhotoFinished:(XRImagePickerController *)picker finishedImage:(UIImage *)image;
@end

@interface XRImagePickerController : UINavigationController

@property (nonatomic, weak) id <XRImagePickerControllerDelegate> delegate;

- (instancetype)initWithAlbumModel:(XRPhotoAlbumModel *)album;

@end


