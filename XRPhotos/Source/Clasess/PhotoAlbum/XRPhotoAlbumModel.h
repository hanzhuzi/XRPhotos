//
//  XRPhotoAlbumModel.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PHFetchResult;
@class PHAsset;
@class PHAssetCollection;
@class XRPhotoAssetModel;

typedef void (^XRPhotoAlbumAutoSetImageBlock)(UIImage * image);

@interface XRPhotoAlbumModel : NSObject

@property (nonatomic, copy) NSString * albumTitle; // 相册标题
@property (nonatomic, strong) UIImage * albumThubImage; // 相册缩略图
@property (nonatomic, assign) NSInteger assetCount; // 资源数
@property (nonatomic, strong) NSMutableArray <XRPhotoAssetModel *>* phAssets; // 相片资源集
@property (nonatomic, strong) NSMutableArray <XRPhotoAssetModel *>* selectedPhAssets; // 选择的相片资源集

// 当Photo图库照片变化时，用来更新图库
@property (nonatomic, strong) PHFetchResult * fetchResult;
@property (nonatomic, strong) PHAssetCollection * assetCollection;

// 请求ID
@property (nonatomic, copy) NSString * requestIdentifier;

// 设置图片的回调
@property (nonatomic, copy) XRPhotoAlbumAutoSetImageBlock autoSetImageBlock;

@end


