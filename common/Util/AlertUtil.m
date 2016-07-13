//
//  AlertUtil.m
//  jianfanjia
//
//  Created by Karos on 16/7/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AlertUtil.h"

@implementation AlertUtil

+ (void)show:(UIViewController *)controller title:(NSString *)title doneBlock:(void(^)(void))doneBlock {
    [self show:controller title:title message:nil cancelText:nil cancelBlock:nil doneText:@"确定" doneBlock:doneBlock completion:nil];
}

+ (void)show:(UIViewController *)controller title:(NSString *)title cancelBlock:(void(^)(void))cancelBlock doneBlock:(void(^)(void))doneBlock {
    [self show:controller title:title message:nil cancelText:@"取消" cancelBlock:cancelBlock doneText:@"确定" doneBlock:doneBlock completion:nil];
}

+ (void)show:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText cancelBlock:(void(^)(void))cancelBlock doneText:(NSString *)doneText doneBlock:(void(^)(void))doneBlock completion:(void(^)(void))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelBlock) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelBlock();
        }];
        [alert addAction:cancel];
    }
    
    if (doneBlock) {
        UIAlertAction *done = [UIAlertAction actionWithTitle:doneText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            doneBlock();
        }];
        [alert addAction:done];
    }
    
    [controller presentViewController:alert animated:YES completion:completion];
}

@end
