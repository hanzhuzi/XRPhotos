//
//  XRPhotoPickerAssetCell.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/14.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import "XRPhotoPickerAssetCell.h"
#import "XRPhotosConfigs.h"
#import "UIImage+XRPhotosCategorys.h"

@implementation XRPhotoPickerAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _assetImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_assetImageView];
        
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.assetImageView.frame) - XR_PhotoAsset_GridCell_SelectButtonWidth - 5.0, 5.0, XR_PhotoAsset_GridCell_SelectButtonWidth, XR_PhotoAsset_GridCell_SelectButtonWidth)];
        _selectButton.userInteractionEnabled = NO;
        [_selectButton setImage:[UIImage imageForResouceName:@"photo_album_asset_select"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageForResouceName:@"photo_album_asset_selected"] forState:UIControlStateSelected];
        [self addSubview:_selectButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _assetImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _selectButton.frame = CGRectMake(CGRectGetMaxX(self.assetImageView.frame) - XR_PhotoAsset_GridCell_SelectButtonWidth - 5.0, 5.0, XR_PhotoAsset_GridCell_SelectButtonWidth, XR_PhotoAsset_GridCell_SelectButtonWidth);
}

@end
