//
//  TabViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tabBar.tintColor = kThemeColor;
    UITabBarItem *my_process = [self.tabBar.items objectAtIndex:0];
    my_process = [my_process initWithTitle:@"工地管理" image:[UIImage imageNamed:@"tab_process_default"] selectedImage:[UIImage imageNamed:@"tab_process_selected"]];
    my_process.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *my = [self.tabBar.items objectAtIndex:1];
    my = [my initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_my_default"] selectedImage:[UIImage imageNamed:@"tab_my_selected"]];
    my.titlePositionAdjustment = UIOffsetMake(0, -2);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

@end
