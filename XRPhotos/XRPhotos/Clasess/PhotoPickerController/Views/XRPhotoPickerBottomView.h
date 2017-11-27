//
//  XRPhotoPickerBottomView.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/16.
//  Copyright © 2017年 是心作佛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XRPhotoPickerBottomViewBtnActionCellBack)(void);

@interface XRPhotoPickerBottomView : UIView

@property (nonatomic, strong) UIButton * previewBtn;
@property (nonatomic, strong) UIButton * finishBtn;
@property (nonatomic, strong) UIView * topLineView;

@property (nonatomic, copy) XRPhotoPickerBottomViewBtnActionCellBack preToViewCallBack;
@property (nonatomic, copy) XRPhotoPickerBottomViewBtnActionCellBack finishSelectCallBack;

- (void)setMaxSelectCount:(NSInteger)maxSelect currentSelectCount:(NSInteger)currentSelect;

@end
