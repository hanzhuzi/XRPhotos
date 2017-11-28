//
//  XRPhotoPickerViewController.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/13.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import "XRPhotoPickerViewController.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "XRPhtoManager.h"
#import "XRPhotoAssetModel.h"
#import "XRPhotoAlbumModel.h"
#import "XRPhotoPickerAssetCell.h"
#import "XRPhotoAlbumListCell.h"
#import "XRPhotoAlbumListView.h"
#import "XRPhotoPickerTakeCameraCell.h"
#import "XRPhotosConfigs.h"
#import "UIImage+XRPhotosCategorys.h"
#import "XRPhotoPickerBottomView.h"
#import "XRPhotoBrowser.h"
#import "XRPhotoPickerNavigationTitleView.h"

@interface XRPhotoPickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XRPhotoAlbumListViewDelegate, XPhotoBrowserDelegate>

// PhotoPicker
@property (nonatomic, strong) UICollectionView * mainCollection;
@property (nonatomic, strong) NSMutableArray <XRPhotoAssetModel *>* assetArray;
@property (nonatomic, strong) NSMutableArray <XRPhotoAssetModel *>* selectedAssetArray;
@property (nonatomic, strong) NSMutableArray <XRPhotoAssetModel *>* tmpSelectedAssetArray;
@property (nonatomic, assign) NSUInteger selectStepCounter;

@property (nonatomic, strong) XRPhtoManager * phManager;
@property (nonatomic, strong) NSString * saveLocalIdentifier;

// PhotoAlbums
@property (nonatomic, strong) NSArray <XRPhotoAlbumModel *>* Allalbums;
@property (nonatomic, strong) XRPhotoAlbumModel * selectedAlbum;
@property (nonatomic, strong) XRPhotoAlbumListView * albumListView;
@property (nonatomic, strong) UIView * albumListMaskView;
@property (nonatomic, assign) CGSize targetSize;

@property (nonatomic, strong) XRPhotoPickerNavigationTitleView * navigationTitleBtn;
@property (nonatomic, assign) BOOL isShowedAlbumList;

@property (nonatomic, strong) XRPhotoPickerBottomView * bottomView;

@end

@implementation XRPhotoPickerViewController

#pragma mark - deinit
- (void)dealloc {
    
}

#pragma mark - Initilizations
// 当PhotoAlbumList在外面时，调用该初始化方法创建照片选择页面
- (instancetype)initWithAlbumModel:(XRPhotoAlbumModel *)albumModel {
    if (self = [super init]) {
        [self initilizationPhotoPicker];
        [_assetArray addObjectsFromArray:albumModel.phAssets];
    }
    return self;
}

// 当PhotoAlbumList在里面时，调用该初始化方法创建照片选择页面
- (instancetype)init {
    if (self = [super init]) {
        [self initilizationPhotoPicker];
    }
    return self;
}

- (void)initilizationPhotoPicker {
    
    _assetArray = [NSMutableArray arrayWithCapacity:10];
    _selectedAssetArray = [NSMutableArray arrayWithCapacity:10];
    _tmpSelectedAssetArray = [NSMutableArray arrayWithCapacity:5];
    
    _selectStepCounter = 0;
    _maxSelectPhotos = 5; // 默认最多选择的照片数为5张
}

#pragma mark - Setter Override
- (void)setMaxSelectPhotos:(NSInteger)maxSelectPhotos {
    if (maxSelectPhotos != _maxSelectPhotos) {
        _maxSelectPhotos = maxSelectPhotos;
    }
    
    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
}

#pragma mark - Lazy Porpertys
- (XRPhtoManager *)phManager {
    if (!_phManager) {
        _phManager = [XRPhtoManager manager];
        _phManager.isAscingForCreation = NO;
    }
    return _phManager;
}

- (UIView *)albumListMaskView {
    if (!_albumListMaskView) {
        _albumListMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, XR_NavigationBar_Height, XR_Screen_Size.width, XR_Screen_Size.height - XR_NavigationBar_Height)];
        _albumListMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _albumListMaskView.alpha = 0;
    }
    return _albumListMaskView;
}

#pragma mark - Setups

- (void)setupMainCollectionView {
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XR_Screen_Size.width, XR_Screen_Size.height - XR_NavigationBar_Height - XR_PhotoPicker_BottomView_Height) collectionViewLayout:flowLayout];
    _mainCollection.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _mainCollection.delegate = self;
    _mainCollection.dataSource = self;
    _mainCollection.alwaysBounceVertical = YES;
    
    [_mainCollection registerClass:[XRPhotoPickerAssetCell class] forCellWithReuseIdentifier:@"XRPhotoPickerAssetCell"];
    [_mainCollection registerClass:[XRPhotoPickerTakeCameraCell class] forCellWithReuseIdentifier:@"XRPhotoPickerTakeCameraCell"];
    [_mainCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:_mainCollection];
}

- (void)setupPhotoAlbumListView {
    
    _targetSize = CGSizeMake(XR_PhotoAlbumList_Cell_Height - XR_PhotoAlbumList_ThumbImageToLeft * 2.0, XR_PhotoAlbumList_Cell_Height - XR_PhotoAlbumList_ThumbImageToTop * 2.0);
    
    // 蒙层
    self.albumListMaskView.alpha = 0.0;
    [self.view addSubview:self.albumListMaskView];
    
    _albumListView = [[XRPhotoAlbumListView alloc] initWithFrame:CGRectMake(0, -XRPhotoAlbumListMaxHeight, XR_Screen_Size.width,  XRPhotoAlbumListMaxHeight)];
    [self.view addSubview:_albumListView];
    [self.view bringSubviewToFront:_albumListView];
    _albumListView.delegate = self;
}

- (void)setupPhotoPickerBottomView {
    
    _bottomView = [[XRPhotoPickerBottomView alloc] initWithFrame:CGRectMake(0, XR_Screen_Size.height - XR_NavigationBar_Height - XR_PhotoPicker_BottomView_Height, XR_Screen_Size.width, XR_PhotoPicker_BottomView_Height)];
    _bottomView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:_bottomView];
    
    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
    
    __weak __typeof(self) weakSelf = self;
    
    // 预览
    _bottomView.preToViewCallBack = ^{
        
        if (weakSelf.selectedAssetArray.count == 0) {
            return;
        }
        
        weakSelf.tmpSelectedAssetArray = [NSMutableArray arrayWithArray:weakSelf.selectedAssetArray];
        
        XRPhotoBrowser * photoBrowser = [[XRPhotoBrowser alloc] initWithDelegate:weakSelf tmpAssets:weakSelf.tmpSelectedAssetArray];
        photoBrowser.zoomPhotosToFill = NO;
        photoBrowser.displayNavArrows = YES;
        photoBrowser.displayActionButton = NO;
        photoBrowser.displaySelectionButtons = NO;
        photoBrowser.alwaysShowControls = NO;
        photoBrowser.enableGrid = NO;
        photoBrowser.enableSwipeToDismiss = NO;
        photoBrowser.startOnGrid = NO;
        photoBrowser.autoPlayOnAppear = NO;
        
        [weakSelf.navigationController pushViewController:photoBrowser animated:YES];
    };
    
    // 完成
    _bottomView.finishSelectCallBack = ^{
        if (weakSelf.selectFinishedBlock) {
            weakSelf.selectFinishedBlock(weakSelf.selectedAssetArray);
        }
    };
}

- (void)setupNavigationBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage backgroundImageWithColor:UIColorFromRGB(0xFFFFFF) size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    UIButton * rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.frame = CGRectMake(0, 0, 50, 44);
    [rightItemBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [rightItemBtn setTitle:@"取消" forState:UIControlStateNormal];
    rightItemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    rightItemBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightItemBtn addTarget:self action:@selector(cancelPhotoPickerAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.navigationTitleBtn = [[XRPhotoPickerNavigationTitleView alloc] init];
    self.navigationTitleBtn.frame = CGRectMake(0, 0, XR_Screen_Size.width - 130, 44);
    [self.navigationTitleBtn configNavigationTitleViewWithTitle:@"所有照片"];
    self.navigationItem.titleView = self.navigationTitleBtn;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlbumListWithAnimate)];
    tapGesture.numberOfTapsRequired = 1;
    [self.navigationTitleBtn addGestureRecognizer:tapGesture];
}

#pragma mark - Actions

- (void)cancelPhotoPickerAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)showAlbumListWithAnimate {
    
    if (self.Allalbums.count == 0) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    if (!_isShowedAlbumList) {
        // 展开
        [UIView animateWithDuration:XR_AlbumListShow_AnimateTime animations:^{
            weakSelf.albumListMaskView.alpha = 1.0;
            CGRect tmpFrame = weakSelf.albumListView.frame;
            tmpFrame.origin.y = 0;
            weakSelf.albumListView.frame = tmpFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                weakSelf.isShowedAlbumList = YES;
            }
        }];
    }
    else {
        // 关闭
        [UIView animateWithDuration:XR_AlbumListShow_AnimateTime animations:^{
            weakSelf.albumListMaskView.alpha = 0;
            CGRect tmpFrame = weakSelf.albumListView.frame;
            tmpFrame.origin.y = -XRPhotoAlbumListMaxHeight;
            weakSelf.albumListView.frame = tmpFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                weakSelf.isShowedAlbumList = NO;
            }
        }];
    }
}

#pragma mark - Request 
- (void)requestAllPhotoAlbums {
    
    __weak __typeof(self) weakSelf = self;
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        // 获取相册
        [self.phManager getAllPhotoAlbumListWithAllowPickVideo:NO targetSize:_targetSize fetchedAlbumList:^(NSArray<XRPhotoAlbumModel *> *albumList) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.Allalbums = albumList;
                [weakSelf.albumListView reloadPhotoAlbumListViewWithAlbums:weakSelf.Allalbums isSelectFirstRow:YES];
                // 默认选择第一个相册
                if (weakSelf.Allalbums.count > 0) {
                    weakSelf.selectedAlbum = weakSelf.Allalbums.firstObject;
                    
                    [weakSelf.navigationTitleBtn configNavigationTitleViewWithTitle:weakSelf.selectedAlbum.albumTitle];
                    [weakSelf.assetArray removeAllObjects];
                    [weakSelf.assetArray addObjectsFromArray:weakSelf.selectedAlbum.phAssets];
                    [weakSelf.mainCollection reloadData];
                }
            });
        }];
    }
    else {
        // 首次授权后最好有个加载提示
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusDenied) {
                // 用户首次授权时点击了 '不允许'，或者手动关闭了访问照片库的权限，需要做引导让用户打开照片库权限
                UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"您已关闭了照片库的访问权限，请点击'去设置'以打开照片库访问权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction * settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                
                [alertCtrl addAction:cancelAction];
                [alertCtrl addAction:settingAction];
                
                [self presentViewController:alertCtrl animated:YES completion:nil];
            }
            else if (status == PHAuthorizationStatusAuthorized) {
                // 用户首次授权时点击了 '好'，开始请求数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 获取相册
                    [self.phManager getAllPhotoAlbumListWithAllowPickVideo:NO targetSize:_targetSize fetchedAlbumList:^(NSArray<XRPhotoAlbumModel *> *albumList) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.Allalbums = albumList;
                            [weakSelf.albumListView reloadPhotoAlbumListViewWithAlbums:weakSelf.Allalbums isSelectFirstRow:YES];
                            // 默认选择第一个相册
                            if (weakSelf.Allalbums.count > 0) {
                                weakSelf.selectedAlbum = weakSelf.Allalbums.firstObject;
                                
                                [weakSelf.navigationTitleBtn configNavigationTitleViewWithTitle:weakSelf.selectedAlbum.albumTitle];
                                [weakSelf.assetArray removeAllObjects];
                                [weakSelf.assetArray addObjectsFromArray:weakSelf.selectedAlbum.phAssets];
                                [weakSelf.mainCollection reloadData];
                            }
                        });
                    }];
                });
            }
        }];
    }
}

#pragma mark - Methods
- (UICollectionViewCell *)cellForPhotoPickerWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    __block XRPhotoPickerAssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XRPhotoPickerAssetCell" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColorFromRGB(0xCCCCCC);
    
    NSInteger index = self.phManager.isAscingForCreation ? indexPath.item : indexPath.item - 1;
    if (index < _assetArray.count) {
        __block XRPhotoAssetModel * assetModel = _assetArray[index];
        
        cell.representedAssetIdentifier = assetModel.phAsset.localIdentifier;
        
        cell.selectButton.selected = [self.selectedAssetArray containsObject:assetModel];
        
        CGFloat itemWidth = (XR_Screen_Size.width - XR_PhotoAsset_Grid_Border * 5.0) / 4.0;
        
        [self.phManager getThumbImageWithAsset:assetModel targetSize:CGSizeMake(itemWidth, itemWidth) completeBlock:^(BOOL isDegrade, UIImage *image) {
            if ([cell.representedAssetIdentifier isEqualToString:assetModel.phAsset.localIdentifier] && image) {
                cell.assetImageView.image = image;
            }
        }];
        
        return cell;
    }
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
}

- (void)takePhotoAction {
    
    __weak __typeof(self) weakSelf = self;
    
    if (![AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]) {
        UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"无法检测到摄像头，请确定是在真机上运行哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertCtrl addAction:cancelAction];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController * pickerCtrl = [[UIImagePickerController alloc] init];
                    pickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
                    pickerCtrl.delegate = weakSelf;
                    [weakSelf presentViewController:pickerCtrl animated:YES completion:nil];
                }
            }
        }];
    }
    else if (authStatus == AVAuthorizationStatusRestricted) {
        UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"系统限制原因，无法使用摄像功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertCtrl addAction:cancelAction];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
    else if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:@"您已关闭了相机的访问权限，请点击'去设置'以打开相机访问权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alertCtrl addAction:cancelAction];
        [alertCtrl addAction:settingAction];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
    else if (authStatus == AVAuthorizationStatusAuthorized) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * pickerCtrl = [[UIImagePickerController alloc] init];
            pickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerCtrl.delegate = self;
            [self presentViewController:pickerCtrl animated:YES completion:nil];
        }
    }
}

#pragma mark - Life Cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupMainCollectionView];
    [self setupPhotoPickerBottomView];
    
    [self setupPhotoAlbumListView];
    [self requestAllPhotoAlbums];
    
    UITapGestureRecognizer * tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlbumListWithAnimate)];
    tapGestrue.numberOfTapsRequired = 1;
    [self.albumListMaskView addGestureRecognizer:tapGestrue];
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

#pragma mark - Delegates
#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assetArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item < _assetArray.count + 1) {
        
        if (self.phManager.isAscingForCreation) {
            if (indexPath.item == _assetArray.count) {
                XRPhotoPickerTakeCameraCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XRPhotoPickerTakeCameraCell" forIndexPath:indexPath];
                cell.backgroundColor = UIColorFromRGB(0x999999);
                return cell;
            }
            else {
                return [self cellForPhotoPickerWithCollectionView:collectionView indexPath:indexPath];
            }
        }
        else {
            if (indexPath.item == 0) {
                XRPhotoPickerTakeCameraCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XRPhotoPickerTakeCameraCell" forIndexPath:indexPath];
                cell.backgroundColor = UIColorFromRGB(0x999999);
                return cell;
            }
            else {
                return [self cellForPhotoPickerWithCollectionView:collectionView indexPath:indexPath];
            }
        }
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.assetArray.count + 1) {
        
        if (self.phManager.isAscingForCreation) {
            if (indexPath.item == self.assetArray.count) {
                // 拍照
                [self takePhotoAction];
            }
            else {
                XRPhotoPickerAssetCell * cell = (XRPhotoPickerAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
                
                if (indexPath.item < self.assetArray.count) {
                    XRPhotoAssetModel * assetModel = self.assetArray[indexPath.item];
                    
                    if ([self.selectedAssetArray containsObject:assetModel]) {
                        // remove
                        [self.selectedAssetArray removeObject:assetModel];
                        self.selectStepCounter--;
                    }
                    else {
                        // add
                        if (self.selectedAssetArray.count < self.maxSelectPhotos) {
                            [self.selectedAssetArray addObject:assetModel];
                        }
                        self.selectStepCounter++;
                        if (self.selectStepCounter > self.maxSelectPhotos) {
                            self.selectStepCounter = self.maxSelectPhotos;
                            // 提示不能选择了
                            if (self.overrunSelectCountBlock) {
                                self.overrunSelectCountBlock();
                            }
                        }
                    }
                    
                    cell.selectButton.selected = [self.selectedAssetArray containsObject:assetModel];
                    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
                }
            }
        }
        else {
            if (indexPath.item == 0) {
                // 拍照
                [self takePhotoAction];
            }
            else {
                XRPhotoPickerAssetCell * cell = (XRPhotoPickerAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
                
                if (indexPath.item - 1 < self.assetArray.count) {
                    XRPhotoAssetModel * assetModel = self.assetArray[indexPath.item - 1];
                    if ([self.selectedAssetArray containsObject:assetModel]) {
                        // remove
                        [self.selectedAssetArray removeObject:assetModel];
                        self.selectStepCounter--;
                    }
                    else {
                        // add
                        if (self.selectedAssetArray.count < self.maxSelectPhotos) {
                            [self.selectedAssetArray addObject:assetModel];
                        }
                        self.selectStepCounter++;
                        if (self.selectStepCounter > self.maxSelectPhotos) {
                            self.selectStepCounter = self.maxSelectPhotos;
                            // 提示不能选择了
                            if (self.overrunSelectCountBlock) {
                                self.overrunSelectCountBlock();
                            }
                        }
                    }
                    
                    cell.selectButton.selected = [self.selectedAssetArray containsObject:assetModel];
                    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
                }
            }
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(XR_PhotoAsset_Grid_Border, XR_PhotoAsset_Grid_Border, XR_PhotoAsset_Grid_Border, XR_PhotoAsset_Grid_Border);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return XR_PhotoAsset_Grid_Border;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return XR_PhotoAsset_Grid_Border;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (XR_Screen_Size.width - XR_PhotoAsset_Grid_Border * 5.0) / 4.0;
    return CGSizeMake(itemWidth, itemWidth);
}

#pragma mark - XRPhotoAlbumListViewDelegate

- (void)didSelectPhotoAlbumList:(XRPhotoAlbumListView *)albumListView selectAlbum:(XRPhotoAlbumModel *)album {
    
    [self showAlbumListWithAnimate];
    
    if (self.selectedAlbum != album) {
        self.selectedAlbum = album;
        
        [self.navigationTitleBtn configNavigationTitleViewWithTitle:self.selectedAlbum.albumTitle];
        [self.assetArray removeAllObjects];
        [self.assetArray addObjectsFromArray:self.selectedAlbum.phAssets];
        [self.mainCollection reloadData];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage] && [info objectForKey:UIImagePickerControllerOriginalImage]) {
        UIImage * originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        originalImage = [originalImage fixOrientation];
        
        // Save to PhotoLibrary
        __weak __typeof(self) weakSelf = self;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest * creationRquest = [PHAssetChangeRequest creationRequestForAssetFromImage:originalImage];
            weakSelf.saveLocalIdentifier = creationRquest.placeholderForCreatedAsset.localIdentifier;
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                XRLog(@"cratation asset error!");
            }
            else {
                PHFetchResult * ftResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[weakSelf.saveLocalIdentifier] options:nil];
                PHAsset * asset = ftResult.firstObject;
                XRPhotoAssetModel * assetModel = [[XRPhotoAssetModel alloc] init];
                assetModel.phAsset = asset;
                [weakSelf.selectedAlbum.phAssets insertObject:assetModel atIndex:0];
                [weakSelf.assetArray removeAllObjects];
                [weakSelf.assetArray addObjectsFromArray:weakSelf.selectedAlbum.phAssets];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.mainCollection performBatchUpdates:^{
                        [weakSelf.mainCollection insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [weakSelf.phManager getAllPhotoAlbumListWithAllowPickVideo:NO targetSize:_targetSize fetchedAlbumList:^(NSArray<XRPhotoAlbumModel *> *albumList) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    weakSelf.Allalbums = albumList;
                                    [weakSelf.albumListView reloadPhotoAlbumListViewWithAlbums:weakSelf.Allalbums isSelectFirstRow:NO];
                                });
                            }];
                        }
                    }];
                });
            }
        }];
        
        if (self.takePhotoFinishedBlock) {
            self.takePhotoFinishedBlock(originalImage);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate & XRPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.selectedAssetArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.selectedAssetArray.count) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat imageSize = MAX(XR_Screen_Size.width, XR_Screen_Size.height) * 1.5;
        CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale); // 大图
        
        XRPhotoAssetModel * asset = self.selectedAssetArray[index];
        MWPhoto * photo = [[MWPhoto alloc] initWithAsset:asset.phAsset targetSize:imageTargetSize];
        return photo;
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    
    if (index < self.selectedAssetArray.count) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat imageSize = MAX(XR_Screen_Size.width, XR_Screen_Size.height) * 1.5;
        CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale); // 缩略图
        
        XRPhotoAssetModel * asset = self.selectedAssetArray[index];
        MWPhoto * photo = [[MWPhoto alloc] initWithAsset:asset.phAsset targetSize:thumbTargetSize];
        return photo;
    }
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return nil;
}
    
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    XRLog(@"didDisplay Index -> %lu", (unsigned long)index);
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
}

#pragma mark - XRPhotoBrowserDelegate
- (NSUInteger)xr_MaxSelectedPhotosForPhotoBrowser {
    return self.maxSelectPhotos;
}

- (void)xr_photoBrowser:(MWPhotoBrowser *)photoBrowser asset:(XRPhotoAssetModel *)asset isSelected:(BOOL)selected {
    
    if (selected) {
        if (![self.tmpSelectedAssetArray containsObject:asset]) {
            [self.tmpSelectedAssetArray addObject:asset];
        }
    }
    else {
        if ([self.tmpSelectedAssetArray containsObject:asset]) {
            [self.tmpSelectedAssetArray removeObject:asset];
        }
    }
}

- (BOOL)xr_photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedWithAsset:(XRPhotoAssetModel *)asset {
    return [self.tmpSelectedAssetArray containsObject:asset];
}

- (void)xr_navigationLeftItemActionForPhotoBrowser {
    // 刷新选择的状态
    [self.selectedAssetArray removeAllObjects];
    [self.selectedAssetArray addObjectsFromArray:self.tmpSelectedAssetArray];
    [self.mainCollection reloadData];
    
    self.selectStepCounter = self.selectedAssetArray.count;
    
    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
}

- (void)xr_finishedBtnActionForPhotoBrowser {
    
    [self.selectedAssetArray removeAllObjects];
    [self.selectedAssetArray addObjectsFromArray:self.tmpSelectedAssetArray];
    [self.mainCollection reloadData];
    [_bottomView setMaxSelectCount:_maxSelectPhotos currentSelectCount:_selectedAssetArray.count];
    
    __weak __typeof(self) weakSelf = self;
    
    if (weakSelf.selectFinishedBlock) {
        weakSelf.selectFinishedBlock(weakSelf.selectedAssetArray);
    }
}

@end






