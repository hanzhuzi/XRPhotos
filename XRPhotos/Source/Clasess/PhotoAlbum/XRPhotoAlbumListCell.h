//
//  XRPhotoAlbumListCell.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XRPhotoAlbumModel;
@interface XRPhotoAlbumListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * thumbImageView;
@property (nonatomic, strong) UILabel * albumTitleLbl;

- (void)configPhotoAlbumCellWithAlbumModel:(XRPhotoAlbumModel *)albumModel;
@end
