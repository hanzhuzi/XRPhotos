//
//  Copyright (c) 2017-2020 是心作佛
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

#import "QKPhotoBrowser.h"
#import "XRPhotosConfigs.h"
#import <MWPhotoBrowser/MWPhotoBrowserPrivate.h>

@interface MWPhotoBrowser ()

- (void)updateNavigation;
- (void)doneButtonPressed:(id)sender;

@end

@interface QKPhotoBrowser ()

@property (nonatomic, strong) UIView * navigationBarView;
@property (nonatomic, strong) UILabel * titleLbl;

@end

@implementation QKPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //---- Custom Navigation Bar -----
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XR_Screen_Size.width, XR_CustomNavigationBarHeight)];
    _navigationBarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navigationBarView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, XR_StatusBarHeight, 55, XR_CustomNavigationBarHeight - XR_StatusBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"icon_close_wh"] forState:UIControlStateNormal];
    [_navigationBarView addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(_navigationBarView.frame) - 100) * 0.5, XR_StatusBarHeight, 100, XR_CustomNavigationBarHeight - XR_StatusBarHeight)];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.textColor = [UIColor whiteColor];
    _titleLbl.font = [UIFont systemFontOfSize:16];
    [_navigationBarView addSubview:_titleLbl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnAction {
    
    if (self.navigationController.presentingViewController != nil) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Override Methods

- (void)updateNavigation {
    
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    if (numberOfPhotos > 1) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:titleForPhotoAtIndex:)]) {
            self.titleLbl.text = [self.delegate photoBrowser:self titleForPhotoAtIndex:self.currentIndex];
        } else {
            self.titleLbl.text = [NSString stringWithFormat:@"%lu %@ %lu", (unsigned long)(self.currentIndex+1), @"/", (unsigned long)numberOfPhotos];
        }
    }
}

@end
