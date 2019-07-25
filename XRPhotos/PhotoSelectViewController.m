//
//  PhotoSelectViewController.m
//  XRPhotos
//
//  Created by xuran on 2017/11/24.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import "PhotoSelectViewController.h"
#import "XRPhotos.h"

@interface PhotoSelectViewController ()<XRPhotoPickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) XRPhotoPickerViewController * photoPicker;

@property (weak, nonatomic) IBOutlet UIImageView *imgVw;

@end

@implementation PhotoSelectViewController

- (IBAction)selectPhotoAction:(id)sender {

    __weak __typeof(self) weakSelf = self;
    
    UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * pickerSelectAction = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        XRPhotoPickerViewController * photoPicker = [[XRPhotoPickerViewController alloc] init];
        photoPicker.delegate = weakSelf;
        photoPicker.isPortrait = YES;
        photoPicker.isAllowCrop = NO;
        photoPicker.isAllowMultipleSelect = YES;
        photoPicker.isPreviewForSingleSelect = YES;
        photoPicker.maxSelectPhotos = 10;
        photoPicker.isSupportCamera = YES;
        photoPicker.cropSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        [weakSelf.navigationController pushViewController:photoPicker animated:true];
    }];
    
    [alertCtrl addAction:takePhotoAction];
    [alertCtrl addAction:pickerSelectAction];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XRPhotoPickerControllerDelegate

// 点击取消
- (void)xr_photoPickerControllerDidCancel:(XRPhotoPickerViewController *)picker {
    
    [picker.navigationController popViewControllerAnimated:YES];
}

// 多选时完成回调
- (void)xr_photoPickerControllerDidFinished:(XRPhotoPickerViewController *)picker didSelectAssets:(NSArray<XRPhotoAssetModel *> *)assets {

    [picker.navigationController popToViewController:self animated:true];
    
    for (XRPhotoAssetModel * assetModel in assets) {
        
    }
}

// 选择资源数超出最大允许选择资源数时回调
- (void)xr_photoPickerControllerDidOverrunMaxAllowSelectCount:(XRPhotoPickerViewController *)picker {
    
    NSLog(@"选择超过了最大选择数量");
}

// 单选时完成回调
- (void)xr_photoPickerController:(XRPhotoPickerViewController *)picker didSelectAssetWithOriginalImage:(UIImage *)originalImaage {
    
    [picker.navigationController popToViewController:self animated:true];
    
    
}

// 单选时裁剪图片完成回调
- (void)xr_photoPickerController:(XRPhotoPickerViewController *)picker didSelectAssetWithCropImage:(UIImage *)cropImaage {
    
    [picker.navigationController popToRootViewControllerAnimated:true];
    
    self.imgVw.image = cropImaage;
    
}

@end
