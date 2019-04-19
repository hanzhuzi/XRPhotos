//
//  XRPhotoPickerAssetCell.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/14.
//  Copyright © 2017年 以戒为师. All rights reserved.
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
        
        _progressLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _progressLbl.center = CGPointMake(CGRectGetWidth(frame) * 0.5, CGRectGetHeight(frame) * 0.5);
        [self addSubview:_progressLbl];
        
        _progressLbl.backgroundColor = UIColorFromRGBAlpha(0x000000, 0.65);
        _progressLbl.textColor = UIColorFromRGBAlpha(0xFFFFFF, 1);
        _progressLbl.textAlignment = NSTextAlignmentCenter;
        _progressLbl.font = [UIFont systemFontOfSize:14];
        _progressLbl.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _assetImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _selectButton.frame = CGRectMake(CGRectGetMaxX(self.assetImageView.frame) - XR_PhotoAsset_GridCell_SelectButtonWidth - 5.0, 5.0, XR_PhotoAsset_GridCell_SelectButtonWidth, XR_PhotoAsset_GridCell_SelectButtonWidth);
    _progressLbl.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _progressLbl.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
}

@end
