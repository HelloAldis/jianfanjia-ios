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
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    item1 = [item1 initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_1_default"] selectedImage:[UIImage imageNamed:@"tab_1_selected"]];
    item1.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
     item2 = [item2 initWithTitle:@"需求列表" image:[UIImage imageNamed:@"tab_2_default"] selectedImage:[UIImage imageNamed:@"tab_2_selected"]];
    item2.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:2];
    item3 = [item3 initWithTitle:@"工地管理" image:[UIImage imageNamed:@"tab_3_default"] selectedImage:[UIImage imageNamed:@"tab_3_selected"]];
    item3.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:3];
    item4 = [item4 initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_4_default"] selectedImage:[UIImage imageNamed:@"tab_4_selected"]];
    item4.titlePositionAdjustment = UIOffsetMake(0, -2);
}

@end
