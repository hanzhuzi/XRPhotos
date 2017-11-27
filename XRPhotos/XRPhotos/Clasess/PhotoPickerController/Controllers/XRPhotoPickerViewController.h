//
//  XRPhotoPickerViewController.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRPhotoAlbumModel;
@class XRPhotoAssetModel;

typedef void(^imagePickerDidCancelCallBack)(void);
typedef void(^imagePickerDidOverrunMaxAllowSelectCountCallBack)(void);
typedef void(^imagePickerTakePhotoFinishedCallBack)(UIImage *image);
typedef void(^imagePickerDidSelectFinishedCallBack)(NSArray <XRPhotoAssetModel *>* selectAssets);

@interface XRPhotoPickerViewController : UIViewController

@property (nonatomic, assign) NSInteger maxSelectPhotos; // 最大可选择的照片数

@property (nonatomic, copy) imagePickerDidCancelCallBack cancelBlock;
@property (nonatomic, copy) imagePickerDidSelectFinishedCallBack selectFinishedBlock;
@property (nonatomic, copy) imagePickerDidOverrunMaxAllowSelectCountCallBack overrunSelectCountBlock;
@property (nonatomic, copy) imagePickerTakePhotoFinishedCallBack takePhotoFinishedBlock;

- (instancetype)initWithAlbumModel:(XRPhotoAlbumModel *)albumModel;

@end
