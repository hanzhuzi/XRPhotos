//
//  XRPhotoPickerTakeCameraCell.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/15.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import "XRPhotoPickerTakeCameraCell.h"
#import "UIImage+XRPhotosCategorys.h"

@implementation XRPhotoPickerTakeCameraCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _cameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 26) * 0.5, (CGRectGetHeight(self.frame) - 23) * 0.5, 26, 23)];
        _cameraImageView.image = [UIImage imageForResouceName:@"photo_album_asset_camera"];
        [self addSubview:_cameraImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _cameraImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - 26) * 0.5, (CGRectGetHeight(self.frame) - 23) * 0.5, 26, 23);
}

@end
