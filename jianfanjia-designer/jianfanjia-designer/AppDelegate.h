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
#define kGtAppId           @"Ec5Iv1QTPz9pBk2ZYFebd"
#define kGtAppKey          @"1zvknC2OFL6mUlWch6tcb3"
#define kGtAppSecret       @"cvNcATrYoo717R8milqyn7"
#else
// Test
#define kGtAppId           @"s7Et91ZLPu8KRwBEtY4AZ8"
#define kGtAppKey          @"8BTWfBSMYM95oFpDOwGYu5"
#define kGtAppSecret       @"QbclEVLgAIA6iWblkTjyD4"

//Product
//#define kGtAppId           @"tE9LwxEKvxACImev1VLiCA"
//#define kGtAppKey          @"5pOVHYbLcS6GrWsp0CTwK3"
//#define kGtAppSecret       @"qX6mtXErCJ7I5ADTLW8P85"
#endif

#define kUMengAppKey       @"5670dd4e67e58eb7220069f6"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstance;

@end

