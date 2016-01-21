//
//  PhoneUtil.m
//  jianfanjia-designer
//
//  Created by Karos on 16/1/21.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PhoneUtil.h"

@implementation PhoneUtil

+ (void)call:(NSString *)phone {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:phone message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alert animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

@end
