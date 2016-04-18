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
- (void)initDefaultNavBarStyle;
- (void)initTranslucentNavBar;
- (void)onClickBack;
- (void)clickBack;

- (void)hideTabbar;
- (void)showTabbar;

@end
