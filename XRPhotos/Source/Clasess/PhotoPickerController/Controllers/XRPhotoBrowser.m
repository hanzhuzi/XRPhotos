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

- (instancetype)initWithDelegate:(id<MWPhotoBrowserDelegate>)delegate tmpAssets:(NSArray <XRPhotoAssetModel *>*)tmpAssets {
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
    
    [_rightItemBtn setImage:[UIImage imageForResourcePath:@"XRPhotos.bundle/photo_album_asset_select" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];
    [_rightItemBtn setImage:[UIImage imageForResourcePath:@"XRPhotos.bundle/photo_album_asset_selected" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateSelected];
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
    
    if (self.isPreviewForSingleSelect) {
        self.rightItemBtn.hidden = YES;
        [self.bottomView.finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.bottomView.finishBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    CGFloat toolBarOriginalY = self.view.bounds.size.height - height - XR_BottomIndicatorHeight;
    
    return CGRectIntegral(CGRectMake(0, toolBarOriginalY, self.view.bounds.size.width, height));
}

- (void)didStartViewingPageAtIndex:(NSUInteger)index {
    [super didStartViewingPageAtIndex:index];
    
    if (self.isPreviewForSingleSelect) {
        self.rightItemBtn.hidden = YES;
        [self.bottomView.finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.bottomView.finishBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    }
    else {
        self.rightItemBtn.hidden = NO;
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
}


@end
