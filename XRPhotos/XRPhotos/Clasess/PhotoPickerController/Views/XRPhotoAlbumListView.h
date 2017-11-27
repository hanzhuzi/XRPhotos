//
//  XRPhotoAlbumListView.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/15.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRPhotoAlbumModel;
@class XRPhotoAlbumListView;

@protocol XRPhotoAlbumListViewDelegate <NSObject>

@required
- (void)didSelectPhotoAlbumList:(XRPhotoAlbumListView *)albumListView selectAlbum:(XRPhotoAlbumModel *)album;

@end

@interface XRPhotoAlbumListView : UIView

@property (nonatomic, weak) id <XRPhotoAlbumListViewDelegate> delegate;

- (void)reloadPhotoAlbumListViewWithAlbums:(NSArray <XRPhotoAlbumModel *> *)albumList isSelectFirstRow:(BOOL)selectFirstRow;

@end
