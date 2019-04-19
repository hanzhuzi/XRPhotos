//
//  XRPhotoAssetModel.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PHAsset;
@interface XRPhotoAssetModel : NSObject

@property (nonatomic, strong) PHAsset * phAsset; // 资源
// 此处的请求ID不可用localIdentifier，因为iCloud是空的
@property (nonatomic, copy) NSString * requestIdentifier; // 请求ID

@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, assign) BOOL isDownloadingFromiCloud; // 是否正在从iCloud下载
@property (nonatomic, strong) NSNumber * downloadProgress; // iCloud下载进度

@end
