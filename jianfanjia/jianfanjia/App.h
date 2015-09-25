//
//  App.h
//  jianfanjia
//
//  Created by JYZ on 15/9/8.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#ifndef jianfanjia_App_h
#define jianfanjia_App_h

#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#define SCREEN_FULL_FRAME [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif
