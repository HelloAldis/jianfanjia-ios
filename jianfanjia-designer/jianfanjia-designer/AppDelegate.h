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

#define kWXAppId           @"wxd4c207f7678adb78"
#define kWXAppSecret       @"a4a56f5a97ec8260547f34e00662f8aa"

#define kQQAppId           @"1104958443" //URL Schemal 需要配置成十六进制 0x41DC53EB ==> QQ41DC53EB
#define kQQAppKey          @"AIz23Ku4k5IswYeF"

#define kWeiboAppKey        @"3796235832"
#define kWeiboAppSecret     @"165fb859e0f1b77200ca0d96958c515a"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstance;

@end

