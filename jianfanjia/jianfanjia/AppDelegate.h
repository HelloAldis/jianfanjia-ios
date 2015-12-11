//
//  AppDelegate.h
//  jianfanjia
//
//  Created by JYZ on 15/8/21.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

// 个推开发者网站中申请App时注册的AppId、AppKey、AppSecret
// Product
//#define kGtAppId           @"YZV748rCe89l8CfZ7dtIF9"
//#define kGtAppKey          @"8GJ1XgPOL9ArriE8xOJDK8"
//#define kGtAppSecret       @"sJtpmFxS0a5sA30Au3iI36"

// Dev
#define kGtAppId           @"t9nLEYqbWI7HUX2QkE79v2"
#define kGtAppKey          @"m2fZOPk3fy5pgq6szkabb7"
#define kGtAppSecret       @"cO8DCexdK69ug14SeeIbg7"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)sharedInstance;

@end

