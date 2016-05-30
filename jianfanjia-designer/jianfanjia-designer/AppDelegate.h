//
//  AppDelegate.h
//  jianfanjia-designer
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

// 个推开发者网站中申请App时注册的AppId、AppKey、AppSecret
#if defined PRO
// product 中的配置
#define kGtAppId           @"tE9LwxEKvxACImev1VLiCA"
#define kGtAppKey          @"5pOVHYbLcS6GrWsp0CTwK3"
#define kGtAppSecret       @"qX6mtXErCJ7I5ADTLW8P85"

#elif defined TEST
// Test 中的配置
#define kGtAppId           @"s7Et91ZLPu8KRwBEtY4AZ8"
#define kGtAppKey          @"8BTWfBSMYM95oFpDOwGYu5"
#define kGtAppSecret       @"QbclEVLgAIA6iWblkTjyD4"

#elif defined DEBUG
// Dev 中的配置
#define kGtAppId           @"Ec5Iv1QTPz9pBk2ZYFebd"
#define kGtAppKey          @"1zvknC2OFL6mUlWch6tcb3"
#define kGtAppSecret       @"cvNcATrYoo717R8milqyn7"

#endif

#ifndef kGtAppId
// 默认的使用 product 中的配置
#define kGtAppId           @"tE9LwxEKvxACImev1VLiCA"
#define kGtAppKey          @"5pOVHYbLcS6GrWsp0CTwK3"
#define kGtAppSecret       @"qX6mtXErCJ7I5ADTLW8P85"

#endif


#define kUMengAppKey       @"5670dd4e67e58eb7220069f6"

#define kWXAppId           @"wx391daabfce27e728"
#define kWXAppSecret       @"f7c8e3e1b5910dd93be2744dacb3a1cc"

#define kQQAppId           @"1104973048" //URL Schemal 需要配置成十六进制 0x41DC8CF8 ==> QQ41DC8CF8
#define kQQAppKey          @"FuDs7s4vJGAEzCrz"

#define kWeiboAppKey        @"10611350"
#define kWeiboAppSecret     @"4a5b93b71687ec9af1ee91cfdfb361d3"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstance;

@end

