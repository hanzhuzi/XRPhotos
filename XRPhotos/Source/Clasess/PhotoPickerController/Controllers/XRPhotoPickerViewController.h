//
//  XRPhotoPickerViewController.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRPhotoPickerViewController;
@class XRPhotoAlbumModel;
@class XRPhotoAssetModel;

@protocol XRPhotoPickerControllerDelegate<NSObject>

@optional

// 选择资源数超出最大允许选择资源数时回调
- (void)xr_photoPickerControllerDidOverrunMaxAllowSelectCount:(XRPhotoPickerViewController *)picker;

// 点击取消
- (void)xr_photoPickerControllerDidCancel:(XRPhotoPickerViewController *)picker;

// 点击完成
- (void)xr_photoPickerControllerDidFinished:(XRPhotoPickerViewController *)picker didSelectAssets:(NSArray <XRPhotoAssetModel *> *)assets;

// 单选时选择照片\拍照返回原图回调
- (void)xr_photoPickerController:(XRPhotoPickerViewController *)picker didSelectAssetWithOriginalImage:(UIImage *)originalImaage;

// 单选时选择照片\拍照返回裁剪的图片回调
- (void)xr_photoPickerController:(XRPhotoPickerViewController *)picker didSelectAssetWithCropImage:(UIImage *)cropImaage;
@end

@interface XRPhotoPickerViewController : UIViewController

@property (nonatomic, assign) BOOL isSupportCamera; // 是否支持拍照
@property (nonatomic, assign) BOOL isAllowMultipleSelect; // 是否允许多选
@property (nonatomic, assign) BOOL isAllowCrop; // 是否允许裁剪
@property (nonatomic, assign) BOOL isPreviewForSingleSelect; // 单选时是否需要预览，且只在单选时有效
@property (nonatomic, assign) BOOL isAscingForCreation; // 是否按照创建日期进行升序排序 默认YES
@property (nonatomic, assign) BOOL isPortrait; // 是否是竖屏

@property (nonatomic, assign) NSInteger maxSelectPhotos; // 最大可选择的照片数
// 为了保证cropSize是正确的，因此必须在设置cropSize之前先设置isPortraint
@property (nonatomic, assign) CGSize cropSize; // 裁剪区域大小
// 横竖屏适配
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
// 状态栏样式
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property (nonatomic, weak) id<XRPhotoPickerControllerDelegate> delegate;

- (instancetype)initWithAlbumModel:(XRPhotoAlbumModel *)albumModel;

@end
