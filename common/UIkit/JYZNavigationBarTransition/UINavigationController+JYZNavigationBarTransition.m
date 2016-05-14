//
//  UINavigationController+JYZNavigationBarTransition.m
//  jianfanjia
//
//  Created by Karos on 16/5/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UINavigationController+JYZNavigationBarTransition.h"
#import "UIViewController+JYZNavigationBarTransition.h"
#import <objc/runtime.h>
#import "JYZSwizzle.h"

@implementation UINavigationController (JYZNavigationBarTransition)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        JYZSwizzleMethod([self class],
//                        @selector(init),
//                        @selector(jyz_init));
//    });
//}
//
//- (id)jyz_init {
//    NSObject *obj = [self jyz_init];
//    [self configureNav];
//    
//    return obj;
//}
//
//- (void)configureNav {
////    [self setNavigationBarHidden:YES animated:NO];
//}

@end
