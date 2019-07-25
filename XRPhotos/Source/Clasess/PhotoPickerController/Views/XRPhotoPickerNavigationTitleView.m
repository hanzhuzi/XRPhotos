//
//  Copyright (c) 2017-2024 是心作佛
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "XRPhotoPickerNavigationTitleView.h"
#import "XRPhotosConfigs.h"

#define XRPhotoPickerNavigationTitleViewIconWidth  17.0f
#define XRPhotoPickerNavigationTitleViewIconHeight 8.5f
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
    
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x000000).CGColor);
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
    _titleLbl.font = [UIFont systemFontOfSize:18];
    _titleLbl.textColor = UIColorFromRGB(0x000000);
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


