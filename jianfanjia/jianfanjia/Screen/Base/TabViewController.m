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
    home = [home initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home_default"] selectedImage:[UIImage imageNamed:@"tab_home_selected"]];
    home.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *pretty_img = [self.tabBar.items objectAtIndex:1];
    pretty_img = [pretty_img initWithTitle:@"装修美图" image:[UIImage imageNamed:@"tab_pretty_img_default"] selectedImage:[UIImage imageNamed:@"tab_pretty_img_selected"]];
    pretty_img.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *requirement = [self.tabBar.items objectAtIndex:2];
     requirement = [requirement initWithTitle:@"装修需求" image:[UIImage imageNamed:@"tab_requirement_default"] selectedImage:[UIImage imageNamed:@"tab_requirement_selected"]];
    requirement.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *my = [self.tabBar.items objectAtIndex:3];
    my = [my initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_my_default"] selectedImage:[UIImage imageNamed:@"tab_my_selected"]];
    my.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    [[NotificationDataManager shared] subscribeAllUnreadCount:^(id value) {
        requirement.badgeValue = [value intValue] > 0 ? [value stringValue] : nil;
    }];
    
    [[NotificationDataManager shared] subscribeAllUnreadCount:^(id value) {
        my.badgeValue = [value intValue] > 0 ? [value stringValue] : nil;
    }];
}

@end
