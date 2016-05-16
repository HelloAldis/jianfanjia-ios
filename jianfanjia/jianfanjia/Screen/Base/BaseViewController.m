//
//  BaseViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/5.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewControllerContainer.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.krs_EnableFakeNavigationBar = YES;
    [self initThemeNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else if (self.navigationController && self.navigationController.viewControllers.firstObject != self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    } else {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DDLogError(@"didReceiveMemoryWarning");
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
}

#pragma mark - UI
- (void)initLeftBackInNav {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)initLeftWhiteBackInNav {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"white_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initThemeNavBar {
    [self initTranslucentNavBarStyle];
    [self initNavBarAttributes];
}

- (void)initNavBarAttributes  {
    NSDictionary * dict = [NSDictionary dictionaryWithObject:kThemeTextColor forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)initTranslucentNavBarStyle {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)initTransparentNavBar:(UIBarStyle)barStyle {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBarStyle:barStyle];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - user actions
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBack {
    [self onClickBack];
}

#pragma mark - Util
- (void)hideTabbar {
    CGRect frame = self.tabBarController.tabBar.frame;
    if (frame.origin.y != kScreenHeight) {
        [UIView animateWithDuration:0.2 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight, CGRectGetWidth(frame), CGRectGetHeight(frame));
        }];
    }
}

- (void)showTabbar {
    CGRect frame = self.tabBarController.tabBar.frame;
    if (frame.origin.y != (kScreenHeight - CGRectGetHeight(frame))) {
        [UIView animateWithDuration:0.2 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight - CGRectGetHeight(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
        }];
    }
}

@end
