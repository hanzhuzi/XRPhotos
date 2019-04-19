//
//  XRPhotosConfigs.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/16.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#ifndef XRPhotosConfigs_h
#define XRPhotosConfigs_h

/** Const defines */

#if DEBUG
#define XRLog(...) NSLog(@"-----> [%@:(%d)] %s", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__); \
NSLog(__VA_ARGS__)
#else
#define XRLog(...) {}
#endif

/**
 * iPhone 机型定义
 */
#define iSiPhone5_5S_SE ([UIScreen instancesRespondToSelector:@selector(currentMode)]) ? \
(((CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(640, 1136))) ? YES : NO) \
|| (CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(1136, 640))) ? YES : NO) : NO

#define iSiPhone6_7_8 ([UIScreen instancesRespondToSelector:@selector(currentMode)]) ? \
(((CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(750, 1334))) ? YES : NO) \
|| (CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(1334, 750))) ? YES : NO) : NO

#define iSiPhone6_7_8Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)]) ? \
(((CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(1242, 2208))) ? YES : NO) \
|| (CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(2208, 1242))) ? YES : NO) : NO

#define iSiPhoneX_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)]) ? \
(((CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(1125, 2436))) ? YES : NO) \
|| (CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(2436, 1125))) ? YES : NO) : NO

#define iSiPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)]) ? \
(((CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(828, 1792))) ? YES : NO) \
|| (CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(1792, 828))) ? YES : NO) : NO

#define iSiPhoneXS_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)]) ? \
(((CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(1242, 2688))) ? YES : NO) \
|| (CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(2688, 1242))) ? YES : NO) : NO

// 是否有刘海
#define iSiPhoneXSerries (iSiPhoneX_XS || iSiPhoneXR || iSiPhoneXS_Max)

#define XR_BottomIndicatorHeight (iSiPhoneXSerries ? 34 : 0)

#define XR_StatusBarHeight (iSiPhoneXSerries ? 44 : 20)

#define XR_NavigationBarHeight 44

#define XR_CustomNavigationBarHeight (iSiPhoneXSerries ? 88 : 64)

#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define XR_Screen_Size [UIScreen mainScreen].bounds.size
#define XR_PhotoAsset_Grid_Border (XR_Screen_Size.width < 375.0 ? 2.0 : 5.0)

/** Static Consts */

static const CGFloat XR_PhotoPicker_BottomView_Height = 50;
static const CGFloat XR_PhotoAsset_GridCell_SelectButtonWidth = 18.0f;

static const CGFloat XR_AlbumListShow_AnimateTime = 0.25;
static const CGFloat XR_PhotoAlbumList_Cell_Height = 75.0;
static const CGFloat XR_PhotoAlbumList_ThumbImageToTop = 10;
static const CGFloat XR_PhotoAlbumList_ThumbImageToLeft = 15.0;

// NNKEY
static NSString * const NNKEY_XR_PHMANAGER_DOWNLOAD_IMAGE_FROM_ICLOUD = @"NNKEY_XR_PHMANAGER_DOWNLOAD_IMAGE_FROM_ICLOUD";

#endif /* XRPhotosConfigs_h */
