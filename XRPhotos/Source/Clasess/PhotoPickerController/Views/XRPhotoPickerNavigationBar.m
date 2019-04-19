//
//  XRPhotoPickerNavigationBar.m
//  XRPhotos
//
//  Created by 以戒为师 on 2017/12/26.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import "XRPhotoPickerNavigationBar.h"
#import "XRPhotosConfigs.h"

@interface XRPhotoPickerNavigationBar()

@end

@implementation XRPhotoPickerNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1.0, CGRectGetWidth(self.frame), 1.0)];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xDEDEDE);
        [self addSubview:_bottomLineView];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
        
        _leftButton.frame = CGRectMake(0, XR_StatusBarHeight, 48, 44);
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    return self;
}

- (void)leftBtnAction {
    
    if (self.leftBtnClickBlock) {
        self.leftBtnClickBlock();
    }
}

- (void)rightBtnAction {
    
    if (self.rightBtnClickBlock) {
        self.rightBtnClickBlock();
    }
}

@end
