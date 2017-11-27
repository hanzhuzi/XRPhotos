//
//  XRPhotoBrowser.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/16.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

/**
 基于`MWPhotoBrowser`定制的图片预览
 */

#import <MWPhotoBrowser/MWPhotoBrowser.h>

@class XRPhotoAssetModel;

// `MWPhotoBrowserDelegate` Addition
@protocol XPhotoBrowserDelegate <MWPhotoBrowserDelegate>

@optional

- (void)xr_navigationLeftItemActionForPhotoBrowser;
- (void)xr_finishedBtnActionForPhotoBrowser;

- (NSUInteger)xr_MaxSelectedPhotosForPhotoBrowser;
- (void)xr_photoBrowser:(MWPhotoBrowser *)photoBrowser asset:(XRPhotoAssetModel *)asset isSelected:(BOOL)selected;
- (BOOL)xr_photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedWithAsset:(XRPhotoAssetModel *)asset;

@end

@interface XRPhotoBrowser : MWPhotoBrowser

@property (nonatomic, strong) UIButton * rightItemBtn;

- (instancetype)initWithDelegate:(id<MWPhotoBrowserDelegate>)delegate tmpAssets:(NSArray *)tmpAssets;

@end
