//
//  XRPhotoPickerNavigationTitleView.h
//  kkShop
//
//  Created by xuran on 2017/11/17.
//  Copyright © 2017年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRPhotoPickerNavigationIconView : UIView

@end

@interface XRPhotoPickerNavigationTitleView : UIView

@property (nonatomic, strong) UILabel * titleLbl;
@property (nonatomic, strong) XRPhotoPickerNavigationIconView * iconView;

- (void)configNavigationTitleViewWithTitle:(NSString *)title;

@end
