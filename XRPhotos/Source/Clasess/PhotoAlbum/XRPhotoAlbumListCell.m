//
//  Copyright (c) 2017-2020 是心作佛
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
