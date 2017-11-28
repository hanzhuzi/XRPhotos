//
//  XRPhotoPickerNavigationTitleView.m
//  kkShop
//
//  Created by xuran on 2017/11/17.
//  Copyright © 2017年 kk. All rights reserved.
//

#import "XRPhotoPickerNavigationTitleView.h"
#import "XRPhotosConfigs.h"

#define XRPhotoPickerNavigationTitleViewIconWidth  18
#define XRPhotoPickerNavigationTitleViewIconHeight 9

@implementation XRPhotoPickerNavigationIconView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
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

@property (nonatomic, strong) NSLayoutConstraint * titleLbllayoutTrailing;
@property (nonatomic, strong) NSLayoutConstraint * titleLbllayoutCenterY;
@property (nonatomic, strong) NSLayoutConstraint * titleLblWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint * titleLblHeightConstraint;

@property (nonatomic, strong) NSLayoutConstraint * iconlayoutLeading;
@property (nonatomic, strong) NSLayoutConstraint * iconlayoutCenterY;
@property (nonatomic, strong) NSLayoutConstraint * iconlayoutWidth;
@property (nonatomic, strong) NSLayoutConstraint * iconlayoutHeight;

@end

@implementation XRPhotoPickerNavigationTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.font = [UIFont boldSystemFontOfSize:18];
        _titleLbl.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_titleLbl];
        
        self.titleLbl.userInteractionEnabled = NO;
        self.titleLbl.translatesAutoresizingMaskIntoConstraints = NO;
        
        _titleLbllayoutTrailing = [NSLayoutConstraint constraintWithItem:self.titleLbl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        _titleLbllayoutCenterY = [NSLayoutConstraint constraintWithItem:self.titleLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraints:@[_titleLbllayoutTrailing, _titleLbllayoutCenterY]];
        
        _titleLblWidthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:0];
        _titleLblHeightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight(self.bounds)];
        [self.titleLbl addConstraints:@[_titleLblWidthConstraint, _titleLblHeightConstraint]];
        
        _iconView = [[XRPhotoPickerNavigationIconView alloc] init];
        _iconView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_iconView];
        
        _iconView.userInteractionEnabled = NO;
        
        _iconlayoutLeading = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLbl attribute:NSLayoutAttributeTrailing multiplier:1 constant:2];
        _iconlayoutCenterY = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraints:@[_iconlayoutLeading, _iconlayoutCenterY]];
        
        _iconlayoutWidth = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:XRPhotoPickerNavigationTitleViewIconWidth];
        _iconlayoutHeight = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:XRPhotoPickerNavigationTitleViewIconHeight];
        [self.iconView addConstraints:@[_iconlayoutWidth, _iconlayoutHeight]];
    }
    return self;
}

- (void)configNavigationTitleViewWithTitle:(NSString *)title {
    
    _titleLbl.text = title;
    [_titleLbl sizeToFit];
    
    [self removeConstraints:@[_titleLbllayoutTrailing, _titleLbllayoutCenterY]];
    [self.titleLbl removeConstraints:@[_titleLblWidthConstraint, _titleLblHeightConstraint]];
    
    _titleLbllayoutTrailing = [NSLayoutConstraint constraintWithItem:self.titleLbl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:(self.titleLbl.frame.size.width * 0.5 - XRPhotoPickerNavigationTitleViewIconWidth * 0.5 + 3)];
    _titleLbllayoutCenterY = [NSLayoutConstraint constraintWithItem:self.titleLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraints:@[_titleLbllayoutTrailing, _titleLbllayoutCenterY]];
    
    _titleLblWidthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:0];
    _titleLblHeightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight(self.bounds)];
    [self.titleLbl addConstraints:@[_titleLblWidthConstraint, _titleLblHeightConstraint]];
    
    [self removeConstraints:@[_iconlayoutLeading, _iconlayoutCenterY]];
    [self.iconView removeConstraints:@[_iconlayoutWidth, _iconlayoutHeight]];
    
    _iconlayoutLeading = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLbl attribute:NSLayoutAttributeTrailing multiplier:1 constant:2];
    _iconlayoutCenterY = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraints:@[_iconlayoutLeading, _iconlayoutCenterY]];
    
    _iconlayoutWidth = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:XRPhotoPickerNavigationTitleViewIconWidth];
    _iconlayoutHeight = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:XRPhotoPickerNavigationTitleViewIconHeight];
    [self.iconView addConstraints:@[_iconlayoutWidth, _iconlayoutHeight]];
    
    // force layout
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end


