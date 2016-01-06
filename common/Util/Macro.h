//
//  Macro.h
//  jianfanjia
//
//  Created by JYZ on 15/10/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define kSynthesizeSingletonForHeader(className) \
\
+ (className *)shared;

#define kSynthesizeSingletonForClass(className) \
\
+ (className *)shared { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#define kScreenFullFrame [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenScale  [UIScreen mainScreen].scale

#define kIs35inchScreen (kScreenHeight == 480)
#define kIs40inchScreen (kScreenHeight == 568)
#define kIs47inchScreen (kScreenHeight == 667)
#define kIs55inchScreen (kScreenHeight == 736)
#define kIsPad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define kIsInstalledWechat ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])

#endif /* Macro_h */
