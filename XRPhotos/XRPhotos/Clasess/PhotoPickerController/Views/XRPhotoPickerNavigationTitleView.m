//
//  XRPhotoPickerNavigationTitleView.m
//  kkShop
//
//  Created by xuran on 2017/11/17.
//  Copyright © 2017年 kk. All rights reserved.
//

#import "XRPhotoPickerNavigationTitleView.h"
#import "XRPhotosConfigs.h"

#define XRPhotoPickerNavigationTitleViewIconWidth  18.0f
#define XRPhotoPickerNavigationTitleViewIconHeight 9.0f
#define XRPhotoPickerNavigationTitleViewIconBorder 3.0f

@implementation XRPhotoPickerNavigationIconView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (self.frame.size.width <= 0 || self.frame.size.height <= 0) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x333333).CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) - 2.0);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.bounds), 0);
    CGContextStrokePath(ctx);
}

@end

@interface XRPhotoPickerNavigationTitleView ()

@end

@implementation XRPhotoPickerNavigationTitleView

- (instancetype)init {
    if (self = [super init]) {
        [self initlizationSubViews];
    }
    return self;
}

- (void)initlizationSubViews {
    
    self.clipsToBounds = YES;
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.font = [UIFont boldSystemFontOfSize:18];
    _titleLbl.textColor = UIColorFromRGB(0x333333);
    [self addSubview:_titleLbl];
    
    _iconView = [[XRPhotoPickerNavigationIconView alloc] init];
    [self addSubview:_iconView];
    _iconView.userInteractionEnabled = NO;
}

- (void)configNavigationTitleViewWithTitle:(NSString *)title {
    
    _titleLbl.text = title;
    [_titleLbl sizeToFit];
    
    _titleLbl.frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(_titleLbl.frame) - XRPhotoPickerNavigationTitleViewIconWidth - XRPhotoPickerNavigationTitleViewIconBorder) * 0.5 + XRPhotoPickerNavigationTitleViewIconWidth * 0.5, (CGRectGetHeight(self.bounds) - CGRectGetHeight(_titleLbl.frame)) * 0.5, _titleLbl.frame.size.width, _titleLbl.frame.size.height);
    
    _iconView.frame = CGRectMake(CGRectGetMaxX(_titleLbl.frame) + XRPhotoPickerNavigationTitleViewIconBorder, (CGRectGetHeight(self.bounds) - XRPhotoPickerNavigationTitleViewIconHeight) * 0.5, XRPhotoPickerNavigationTitleViewIconWidth, XRPhotoPickerNavigationTitleViewIconHeight);
}

@end


