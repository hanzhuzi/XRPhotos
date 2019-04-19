//
//  UIImage+XRPhotosCategorys.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/16.
//  Copyright © 2017年 以戒为师. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XRPhotosCategorys)
+ (UIImage *)imageForResouceName:(NSString *)imageName;
- (UIImage *)fixOrientation;
+ (UIImage *)backgroundImageWithColor:(UIColor *)backgroundColor size:(CGSize)size;
@end
