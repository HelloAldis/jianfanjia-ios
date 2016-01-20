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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBar.tintColor = kThemeColor;
    UITabBarItem *home = [self.tabBar.items objectAtIndex:0];
    home = [home initWithTitle:@"我的业主" image:[UIImage imageNamed:@"tab_my_user_default"] selectedImage:[UIImage imageNamed:@"tab_my_user_selected"]];
    home.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *my_process = [self.tabBar.items objectAtIndex:1];
    my_process = [my_process initWithTitle:@"工地管理" image:[UIImage imageNamed:@"tab_process_default"] selectedImage:[UIImage imageNamed:@"tab_process_selected"]];
    my_process.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *my = [self.tabBar.items objectAtIndex:2];
    my = [my initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_my_default"] selectedImage:[UIImage imageNamed:@"tab_my_selected"]];
    my.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    [[NotificationDataManager shared] subscribeAllUnreadCount:^(id value) {
        my_process.badgeValue = [value intValue] > 0 ? [value stringValue] : nil;
    }];
}

@end
