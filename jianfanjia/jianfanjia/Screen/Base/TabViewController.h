//
//  TabViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UITabBarController

@property(strong, nonatomic) UIViewController *tapHome;
@property(strong, nonatomic) UIViewController *tapBeautifulImg;
@property(strong, nonatomic) UIViewController *tapDecDiary;
@property(strong, nonatomic) UIViewController *tapRequirement;
@property(strong, nonatomic) UIViewController *tapMy;

@end
