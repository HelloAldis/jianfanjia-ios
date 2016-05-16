//
//  BaseViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/9/5.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>

- (void)initLeftBackInNav;
- (void)initLeftWhiteBackInNav;
- (void)initStatusBarStyle:(UIStatusBarStyle)barStyle;
- (void)initThemeNavBar;
- (void)initTranslucentNavBarStyle;
- (void)initTransparentNavBar:(UIBarStyle)barStyle;
- (void)onClickBack;
- (void)clickBack;

- (void)hideTabbar;
- (void)showTabbar;

@end
