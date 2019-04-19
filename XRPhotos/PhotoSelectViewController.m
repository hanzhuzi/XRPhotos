//
//  PhotoSelectViewController.m
//  XRPhotos
//
//  Created by xuran on 2017/11/24.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import "PhotoSelectViewController.h"
#import "XRPhotoPickerViewController.h"

@interface PhotoSelectViewController ()<XRPhotoPickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) XRPhotoPickerViewController * photoPicker;

@end

@implementation PhotoSelectViewController

- (IBAction)selectPhotoAction:(id)sender {

    __weak __typeof(self) weakSelf = self;
    
    UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * pickerSelectAction = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.photoPicker = [[XRPhotoPickerViewController alloc] init];
        weakSelf.photoPicker.delegate = weakSelf;
        weakSelf.photoPicker.isPortrait = YES;
        weakSelf.photoPicker.isAllowCrop = YES;
        weakSelf.photoPicker.isAllowMultipleSelect = NO;
        weakSelf.photoPicker.cropSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        [weakSelf.navigationController pushViewController:weakSelf.photoPicker animated:true];
    }];
    
    [alertCtrl addAction:takePhotoAction];
    [alertCtrl addAction:pickerSelectAction];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XRImagePickerControllerDelegate

- (BOOL)xr_imagePickerControllerSortedByAscingCreation {
    return NO;
}

// 返回允许选择的最大资源数
- (NSInteger)xr_imagePickerControllerAllowMaxSelectCount {
    return 10;
}

// 点击取消
- (void)xr_imagePickerControllerDidCancel:(XRPhotoPickerViewController *)picker {
    
    [picker.navigationController popViewControllerAnimated:YES];
}

// 点击完成
- (void)xr_imagePickerControllerDidFinished:(XRPhotoPickerViewController *)picker didSelectAssets:(NSArray <XRPhotoAssetModel *> *)assets {

}

// 选择资源数超出最大允许选择资源数时回调
- (void)xr_imagePickerControllerDidOverrunMaxAllowSelectCount:(XRPhotoPickerViewController *)picker {
    
}

// 拍照完成后回调
- (void)xr_imagePickerControllerTakePhotoFinished:(XRPhotoPickerViewController *)picker finishedImage:(UIImage *)image {
    
}

@end
