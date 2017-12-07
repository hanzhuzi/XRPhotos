//
//  XRImagePickerController.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import "XRImagePickerController.h"
#import "XRPhotoAlbumModel.h"
#import "XRPhotoPickerViewController.h"
#import "XRPhotoAssetModel.h"

@interface XRImagePickerController ()
{
    @private
    XRPhotoPickerViewController * _photoPicker;
}
@end

@implementation XRImagePickerController
@dynamic delegate;

- (instancetype)init {
    if (self = [super init]) {
        XRPhotoPickerViewController * picker = [self initilizationImagePickerControllerWithAlbum:nil];
        self = [self initWithRootViewController:picker];
        _photoPicker = picker;
    }
    return self;
}

- (instancetype)initWithAlbumModel:(XRPhotoAlbumModel *)album {
    if (self = [super init]) {
        XRPhotoPickerViewController * picker = [self initilizationImagePickerControllerWithAlbum:album];
        self = [self initWithRootViewController:picker];
        _photoPicker = picker;
    }
    return self;
}

- (XRPhotoPickerViewController *)initilizationImagePickerControllerWithAlbum:(XRPhotoAlbumModel *)album {
    
    XRPhotoPickerViewController * picker = nil;
    
    if (album) {
        picker = [[XRPhotoPickerViewController alloc] initWithAlbumModel:album];
    }
    else {
        picker = [[XRPhotoPickerViewController alloc] init];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    picker.cancelBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_imagePickerControllerDidCancel:)]) {
            [weakSelf.delegate xr_imagePickerControllerDidCancel:weakSelf];
        }
    };
    
    picker.selectFinishedBlock = ^(NSArray <XRPhotoAssetModel *>* selectAssets) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_imagePickerControllerDidFinished:didSelectAssets:)]) {
            [weakSelf.delegate xr_imagePickerControllerDidFinished:weakSelf didSelectAssets:selectAssets];
        }
    };
    
    picker.overrunSelectCountBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_imagePickerControllerDidOverrunMaxAllowSelectCount:)]) {
            [weakSelf.delegate xr_imagePickerControllerDidOverrunMaxAllowSelectCount:weakSelf];
        }
    };
    
    picker.takePhotoFinishedBlock = ^(UIImage *image) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(xr_imagePickerControllerTakePhotoFinished:finishedImage:)]) {
            [weakSelf.delegate xr_imagePickerControllerTakePhotoFinished:weakSelf finishedImage:image];
        }
    };
    
    return picker;
}

- (void)setupPickerConfiguration {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xr_imagePickerControllerAllowMaxSelectCount)]) {
        _photoPicker.maxSelectPhotos = [self.delegate xr_imagePickerControllerAllowMaxSelectCount];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xr_imagePickerControllerSortedByAscingCreation)]) {
        _photoPicker.isAscingForCreation = [self.delegate xr_imagePickerControllerSortedByAscingCreation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupPickerConfiguration];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self isViewLoaded]) {
        [self setupPickerConfiguration];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self isViewLoaded]) {
        [self setupPickerConfiguration];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


