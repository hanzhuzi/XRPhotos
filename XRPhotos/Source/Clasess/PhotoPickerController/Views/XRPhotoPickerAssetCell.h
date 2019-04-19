//
//  XRPhotoPickerAssetCell.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/14.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRPhotoPickerAssetCell : UICollectionViewCell

@property (nonatomic, copy) NSString * representedAssetIdentifier;
@property (nonatomic, strong) UIImageView * assetImageView;
@property (nonatomic, strong) UIButton * selectButton;

@property (nonatomic, strong) UILabel * progressLbl;

@end
