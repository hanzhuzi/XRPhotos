//
//  XRPhotoAlbumListView.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/15.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import "XRPhotoAlbumListView.h"
#import "XRPhotoAlbumListCell.h"
#import "XRPhotoAlbumModel.h"
#import "XRPhotosConfigs.h"

@interface XRPhotoAlbumListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) NSArray <XRPhotoAlbumModel *>* Allalbums;

@end

@implementation XRPhotoAlbumListView

- (instancetype)init {
    if (self = [super init]) {
        [self setupMainTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupMainTableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _mainTableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setupMainTableView {
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    _mainTableView.estimatedRowHeight = 0;
    _mainTableView.estimatedSectionFooterHeight = 0;
    _mainTableView.estimatedSectionHeaderHeight = 0;
    
    [_mainTableView registerClass:[XRPhotoAlbumListCell class] forCellReuseIdentifier:@"XRPhotoAlbumListCell"];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.tableHeaderView = [[UIView alloc] init];
    
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_mainTableView];
}

- (void)reloadPhotoAlbumListViewWithAlbums:(NSArray <XRPhotoAlbumModel *> *)albumList isSelectFirstRow:(BOOL)selectFirstRow {
    self.Allalbums = albumList;
    [self.mainTableView reloadData];
    
    if (selectFirstRow && self.Allalbums.count > 0) {
        [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

#pragma mark - UITableViewDelagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.Allalbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.Allalbums.count) {
        XRPhotoAlbumListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XRPhotoAlbumListCell"];
        if (!cell) {
            cell = [[XRPhotoAlbumListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"XRPhotoAlbumListCell"];
        }
        
        XRPhotoAlbumModel * model = self.Allalbums[indexPath.row];
        [cell configPhotoAlbumCellWithAlbumModel:model];
        return cell;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return XR_PhotoAlbumList_Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.Allalbums.count) {
        XRPhotoAlbumModel * album = self.Allalbums[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPhotoAlbumList:selectAlbum:)]) {
            [self.delegate didSelectPhotoAlbumList:self selectAlbum:album];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
