//
//  XRPhotoAssetModel.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PHAsset;
@interface XRPhotoAssetModel : NSObject

@property (nonatomic, strong) PHAsset * phAsset; // 资源
@property (nonatomic, copy) NSString * requestIdentifier; // 请求ID

@end
