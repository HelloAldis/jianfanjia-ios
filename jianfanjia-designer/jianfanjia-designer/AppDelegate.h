//
//  AppDelegate.h
//  jianfanjia-designer
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

// 个推开发者网站中申请App时注册的AppId、AppKey、AppSecret
#ifdef DEBUG
// Dev
#define kGtAppId           @"t9nLEYqbWI7HUX2QkE79v2"
#define kGtAppKey          @"m2fZOPk3fy5pgq6szkabb7"
#define kGtAppSecret       @"cO8DCexdK69ug14SeeIbg7"
#else
// Test
#define kGtAppId           @"SLKdGK8YIr9wns6NPEL8v8"
#define kGtAppKey          @"O3oCpGEAVp7NjP67JbMPt5"
#define kGtAppSecret       @"MM8Ybygbsz7EUvMoNpkHd5"

//Product
//#define kGtAppId           @"YZV748rCe89l8CfZ7dtIF9"
//#define kGtAppKey          @"8GJ1XgPOL9ArriE8xOJDK8"
//#define kGtAppSecret       @"sJtpmFxS0a5sA30Au3iI36"
#endif

#define kUMengAppKey       @"55ffb334e0f55a84d500247f"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstance;

@end

