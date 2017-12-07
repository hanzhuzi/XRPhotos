//
//  UINavigationBar+Track.m
//  iOS11Fits
//
//  Created by shixinzuofo on 2017/12/1.
//  Copyright © 2017年 shixinzuofo. All rights reserved.
//

#import "UINavigationBar+Track.h"
#import <objc/runtime.h>

static const CGFloat kLeftRightItemEdgeInsetsDefaultValue = 8.0;

@implementation UINavigationBar (Track)

+ (void)load {
    static dispatch_once_t onceToken = 0l;
    dispatch_once(&onceToken, ^{
        // Class
        Class theClass = [self class];
        
        // SEL
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzlingSelector = @selector(xr_layoutSubViews);
        
        // Method
        Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
        Method swizzlingMethod = class_getInstanceMethod(theClass, swizzlingSelector);
        
        BOOL isAddMethod = class_addMethod(theClass, originalSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        if (isAddMethod) {
            // Replace
            class_replaceMethod(theClass, swizzlingSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            // Exchange
            method_exchangeImplementations(originalMethod, swizzlingMethod);
        }
    });
}

#pragma mark - Method Swizzling
- (void)xr_layoutSubViews {
    
    // Call `layoutSubViews` Implementation
    [self xr_layoutSubViews];
    
    // adjust iOS 11 leftBarButtonItem shifted to right problem
    if (@available(iOS 11, *)) {
        UIEdgeInsets barMargins = self.layoutMargins;
        barMargins.left = 0;
        barMargins.right = 0;
        self.layoutMargins = barMargins;
        for (UIView * subView in self.subviews) {
            if ([NSStringFromClass([subView class]) containsString:@"ContentView"]) {
                UIEdgeInsets contentViewMargins = subView.layoutMargins;
                contentViewMargins.left = kLeftRightItemEdgeInsetsDefaultValue;
                contentViewMargins.right = kLeftRightItemEdgeInsetsDefaultValue;
                subView.layoutMargins = contentViewMargins;
                break;
            }
        }
    }
}

@end
