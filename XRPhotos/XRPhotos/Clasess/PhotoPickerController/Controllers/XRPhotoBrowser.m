//
//  XRPhotoBrowser.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/16.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import "XRPhotoBrowser.h"
#import "XRPhotoPickerBottomView.h"
#import "XRPhotosConfigs.h"
#import "XRPhotoAssetModel.h"
#import "MWPhotoBrowserPrivate.h"
#import "UIImage+XRPhotosCategorys.h"

// Super Class Method Forward Declaration
@interface MWPhotoBrowser ()

- (void)didStartViewingPageAtIndex:(NSUInteger)index;
- (void)performLayout;
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation;
@end

@protocol XPhotoBrowserDelegate;

@interface XRPhotoBrowser ()

// SubClass Porpertys
@property (nonatomic, strong) NSArray <XRPhotoAssetModel *>* tmpAssets;

@property (nonatomic, strong) XRPhotoPickerBottomView * bottomView;

@end

@implementation XRPhotoBrowser

- (instancetype)initWithDelegate:(id<MWPhotoBrowserDelegate>)delegate tmpAssets:(NSArray *)tmpAssets {
    if (self = [super initWithDelegate:delegate]) {
        self.tmpAssets = [NSArray arrayWithArray:tmpAssets];
    }
    
    return self;
}

- (void)setupPhotoPickerBottomView {
    
    _bottomView = [[XRPhotoPickerBottomView alloc] initWithFrame:CGRectMake(0, 0, XR_Screen_Size.width, XR_PhotoPicker_BottomView_Height)];
    _bottomView.backgroundColor = [UIColor clearColor];
    
    _bottomView.previewBtn.hidden = YES;
    _bottomView.topLineView.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    _bottomView.finishSelectCallBack = ^{
        if (weakSelf.delegate && [weakSelf.delegate conformsToProtocol:@protocol(XPhotoBrowserDelegate)]) {
            id <XPhotoBrowserDelegate> xr_delegate = (id<XPhotoBrowserDelegate>)weakSelf.delegate;
            if ([xr_delegate respondsToSelector:@selector(xr_finishedBtnActionForPhotoBrowser)]) {
                [xr_delegate xr_finishedBtnActionForPhotoBrowser];
            }
        }
    };
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XPhotoBrowserDelegate)]) {
        id <XPhotoBrowserDelegate> xr_delegate = (id<XPhotoBrowserDelegate>)self.delegate;
        if ([xr_delegate respondsToSelector:@selector(xr_MaxSelectedPhotosForPhotoBrowser)]) {
            NSInteger maxSelectCount = [xr_delegate xr_MaxSelectedPhotosForPhotoBrowser];
            [_bottomView setMaxSelectCount:maxSelectCount currentSelectCount:1];
        }
    }
}

- (void)setupNavigation {
    
    _rightItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XR_PhotoAsset_GridCell_SelectButtonWidth, XR_PhotoAsset_GridCell_SelectButtonWidth)];
    [_rightItemBtn setImage:[UIImage imageForResouceName:@"photo_album_asset_select"] forState:UIControlStateNormal];
    [_rightItemBtn setImage:[UIImage imageForResouceName:@"photo_album_asset_selected"] forState:UIControlStateSelected];
    [_rightItemBtn addTarget:self action:@selector(navigationRightItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeftItemAction)];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightItemBtn];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPhotoPickerBottomView];
    [self setupNavigation];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)navigationLeftItemAction {

    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XPhotoBrowserDelegate)]) {
        id <XPhotoBrowserDelegate> xr_delegate = (id<XPhotoBrowserDelegate>)self.delegate;
        if ([xr_delegate respondsToSelector:@selector(xr_navigationLeftItemActionForPhotoBrowser)]) {
            [xr_delegate xr_navigationLeftItemActionForPhotoBrowser];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightItemAction {
    
    self.rightItemBtn.selected = !self.rightItemBtn.selected;
    
    if (self.currentIndex < self.tmpAssets.count) {
        XRPhotoAssetModel * asset = self.tmpAssets[self.currentIndex];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(XPhotoBrowserDelegate)]) {
            id <XPhotoBrowserDelegate> xr_delegate = (id<XPhotoBrowserDelegate>)self.delegate;
            if ([xr_delegate respondsToSelector:@selector(xr_photoBrowser:asset:isSelected:)]) {
                [xr_delegate xr_photoBrowser:self asset:asset isSelected:self.rightItemBtn.selected];
            }
        }
    }
}

#pragma mark - Override Methods

- (void)performLayout {
    [super performLayout];
    
    for (UIView * subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIToolbar class]]) {
            UIToolbar * toolBar = (UIToolbar *)subView;
            [toolBar setItems:nil];
            [toolBar addSubview:self.bottomView];
            break;
        }
    }
}

- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation {
    CGFloat height = XR_PhotoPicker_BottomView_Height;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        UIInterfaceOrientationIsLandscape(orientation)) {
        height = XR_PhotoPicker_BottomView_Height;
    }
    CGFloat toolBarOriginalY = self.view.bounds.size.height - height;
    if (iSiPhoneX) {
        toolBarOriginalY = self.view.bounds.size.height - XR_Virtual_Bottom_Height - height;
    }
    return CGRectIntegral(CGRectMake(0, toolBarOriginalY, self.view.bounds.size.width, height));
}

- (void)didStartViewingPageAtIndex:(NSUInteger)index {
    [super didStartViewingPageAtIndex:index];
    
    // Update Bottom View
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XPhotoBrowserDelegate)]) {
        id <XPhotoBrowserDelegate> xr_delegate = (id<XPhotoBrowserDelegate>)self.delegate;
        if ([xr_delegate respondsToSelector:@selector(xr_MaxSelectedPhotosForPhotoBrowser)]) {
            NSInteger maxSelectCount = [xr_delegate xr_MaxSelectedPhotosForPhotoBrowser];
            [_bottomView setMaxSelectCount:maxSelectCount currentSelectCount:self.currentIndex + 1];
        }
    }
    
    // Update Navigation Button
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XPhotoBrowserDelegate)]) {
        id <XPhotoBrowserDelegate> xr_delegate = (id<XPhotoBrowserDelegate>)self.delegate;
        if ([xr_delegate respondsToSelector:@selector(xr_photoBrowser:isPhotoSelectedWithAsset:)]) {
            if (index < self.tmpAssets.count) {
                XRPhotoAssetModel * asset = self.tmpAssets[index];
                self.rightItemBtn.selected = [xr_delegate xr_photoBrowser:self isPhotoSelectedWithAsset:asset];
            }
        }
    }
}

@end
