//
//  XRPhotoAssetModel.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import "XRPhotoAssetModel.h"
#import <Photos/Photos.h>

@implementation XRPhotoAssetModel

- (void)setPhAsset:(PHAsset *)phAsset {
    if (phAsset) {
        _phAsset = phAsset;
        _requestIdentifier = _phAsset.localIdentifier;
    }
}

- (BOOL)isEqual:(id)object {
    if (object && [object isKindOfClass:[XRPhotoAssetModel class]]) {
        return [((XRPhotoAssetModel *)object).phAsset.localIdentifier isEqualToString:self.phAsset.localIdentifier];
    }
    return NO;
}

@end
