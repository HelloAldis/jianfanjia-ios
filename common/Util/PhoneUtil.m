//
//  PhoneUtil.m
//  jianfanjia-designer
//
//  Created by Karos on 16/1/21.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PhoneUtil.h"

@implementation PhoneUtil

+ (void)call:(NSString *)title phone:(NSString *)phone {
    UIViewController *controller;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    } else {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    [AlertUtil show:controller title:title message:phone cancelText:@"取消" cancelBlock:^{
        
    } doneText:@"呼叫" doneBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]];
    } completion:nil];
}

+ (void)call:(NSString *)phone {
    [self call:phone phone:nil];
}

@end
