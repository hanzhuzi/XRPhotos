//
//  XRPhotoAlbumModel.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import "XRPhotoAlbumModel.h"

@implementation XRPhotoAlbumModel

- (void)setAlbumThubImage:(UIImage *)albumThubImage {
    if (albumThubImage) {
        _albumThubImage = albumThubImage;
        if (_autoSetImageBlock) {
            _autoSetImageBlock(_albumThubImage);
        }
    }
}

- (NSInteger)assetCount {
    return _phAssets.count;
}

@end
