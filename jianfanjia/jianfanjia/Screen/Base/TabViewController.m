//
//  TabViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TabViewController.h"
#import "ViewControllerContainer.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.tabBar.tintColor = kThemeColor;
    UITabBarItem *home = [self.tabBar.items objectAtIndex:0];
    home = [home initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home_default"] selectedImage:[UIImage imageNamed:@"tab_home_selected"]];
    home.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *pretty_img = [self.tabBar.items objectAtIndex:1];
    pretty_img = [pretty_img initWithTitle:@"装修美图" image:[UIImage imageNamed:@"tab_pretty_img_default"] selectedImage:[UIImage imageNamed:@"tab_pretty_img_selected"]];
    pretty_img.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *decDiary = [self.tabBar.items objectAtIndex:2];
    decDiary = [decDiary initWithTitle:@"装修日记" image:[UIImage imageNamed:@"tab_pretty_img_default"] selectedImage:[UIImage imageNamed:@"tab_pretty_img_selected"]];
    decDiary.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *requirement = [self.tabBar.items objectAtIndex:3];
    requirement = [requirement initWithTitle:@"我要装修" image:[UIImage imageNamed:@"tab_requirement_default"] selectedImage:[UIImage imageNamed:@"tab_requirement_selected"]];
    requirement.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *my = [self.tabBar.items objectAtIndex:4];
    my = [my initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_my_default"] selectedImage:[UIImage imageNamed:@"tab_my_selected"]];
    my.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    [[NotificationDataManager shared] subscribeAppBadgeNumber:^(NSInteger count) {
        my.badgeNumber = count > 0 ? kBadgeStyleDot : @"";
    }];
    
    [[NotificationDataManager shared] refreshUnreadCount];
}

@end
