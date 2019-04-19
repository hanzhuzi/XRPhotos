//
//  XRPhotoAlbumListCell.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import "XRPhotoAlbumListCell.h"
#import "XRPhotoAlbumModel.h"
#import "XRPhotosConfigs.h"

@implementation XRPhotoAlbumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _thumbImageView = [UIImageView new];
        _thumbImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_thumbImageView];
        
        _albumTitleLbl = [UILabel new];
        _albumTitleLbl.textAlignment = NSTextAlignmentLeft;
        _albumTitleLbl.font = [UIFont boldSystemFontOfSize:15];
        _albumTitleLbl.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_albumTitleLbl];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat thumbImageHeight = self.contentView.frame.size.height - XR_PhotoAlbumList_ThumbImageToTop * 2.0;
    _thumbImageView.frame = CGRectMake(XR_PhotoAlbumList_ThumbImageToLeft, XR_PhotoAlbumList_ThumbImageToTop, thumbImageHeight, thumbImageHeight);
    
    _albumTitleLbl.frame = CGRectMake(CGRectGetMaxX(_thumbImageView.frame) + 10, 0, CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(_thumbImageView.frame) - 35, CGRectGetHeight(self.contentView.frame));
}

- (void)configPhotoAlbumCellWithAlbumModel:(XRPhotoAlbumModel *)albumModel {
    
    __weak __typeof(self) weakSelf = self;
    if (albumModel) {
        _albumTitleLbl.text = [NSString stringWithFormat:@"%@ (%ld)", albumModel.albumTitle, (long)albumModel.assetCount];
        // 设置已下载的图片
        _thumbImageView.image = albumModel.albumThubImage;
        
        // 异步设置图片
        albumModel.autoSetImageBlock = ^(UIImage * image) {
            weakSelf.thumbImageView.image = image;
        };
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
