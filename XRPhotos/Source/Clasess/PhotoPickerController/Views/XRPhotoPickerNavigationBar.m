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

#import "XRPhotoPickerNavigationBar.h"
#import "XRPhotosConfigs.h"

@interface XRPhotoPickerNavigationBar()

@end

@implementation XRPhotoPickerNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.16].CGColor;
        self.layer.shadowOffset = CGSizeMake(-1, -1);
        self.layer.shadowRadius = 3;
        
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
