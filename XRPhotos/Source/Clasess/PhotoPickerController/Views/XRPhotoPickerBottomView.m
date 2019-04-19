//
//  XRPhotoPickerBottomView.m
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/16.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import "XRPhotoPickerBottomView.h"
#import "XRPhotosConfigs.h"

@interface XRPhotoPickerBottomView()

@end

@implementation XRPhotoPickerBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewBtn.frame = CGRectMake(0, 0, 60.0, CGRectGetHeight(self.bounds));
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _previewBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_previewBtn];
        [_previewBtn addTarget:self action:@selector(preToViewAction) forControlEvents:UIControlEventTouchUpInside];
        
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 80.0 - 14, (CGRectGetHeight(self.bounds) - 30) * 0.5, 80.0, 30);
        [_finishBtn setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        [_finishBtn setTitle:@"完成0/0" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_finishBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateDisabled];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _finishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.layer.cornerRadius = 3.0;
        [self addSubview:_finishBtn];
        [_finishBtn addTarget:self action:@selector(finishSelectAction) forControlEvents:UIControlEventTouchUpInside];
        
        _topLineView = [[UIView alloc] init];
        _topLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.0 / [UIScreen mainScreen].scale);
        _topLineView.backgroundColor = UIColorFromRGB(0xECECEC);
        [self addSubview:_topLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _previewBtn.frame = CGRectMake(0, 0, 60.0, CGRectGetHeight(self.bounds));
    _finishBtn.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 80.0 - 14, (CGRectGetHeight(self.bounds) - 30) * 0.5, 80.0, 30);
    _topLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.0 / [UIScreen mainScreen].scale);
}

- (void)setMaxSelectCount:(NSInteger)maxSelect currentSelectCount:(NSInteger)currentSelect {
    
    if (currentSelect > 0) {
        _finishBtn.enabled = YES;
        [_finishBtn setBackgroundColor:UIColorFromRGB(0x2170E8)];
        [_finishBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    }
    else {
        _finishBtn.enabled = NO;
        [_finishBtn setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        [_finishBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    }
    NSString * finishBtnText = [NSString stringWithFormat:@"完成%ld/%ld", (long)currentSelect, (long)maxSelect];
    [_finishBtn setTitle:finishBtnText forState:UIControlStateNormal];
}

- (void)preToViewAction {
    if (self.preToViewCallBack) {
        self.preToViewCallBack();
    }
}

- (void)finishSelectAction {
    if (self.finishSelectCallBack) {
        self.finishSelectCallBack();
    }
}

@end


