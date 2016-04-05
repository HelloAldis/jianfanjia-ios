//
//  HUDUtil.m
//  jianfanjia
//
//  Created by JYZ on 15/9/15.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "HUDUtil.h"
#import "AppDelegate.h"

@implementation HUDUtil

+ (void)showText:(NSString *)text delayShow:(CGFloat)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUDUtil showText:text delayHide:2];
    });
}

+ (void)showText:(NSString *)text delayHide:(CGFloat)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:delay];
}

+ (void)showErrText:(NSString *)text {
    [HUDUtil showText:text delayHide:1.5];
}

+ (void)showSuccessText:(NSString *)text {
    [HUDUtil showText:text delayHide:1.5];
}

+ (void)showWait {
    [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
}

+ (void)showWait:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
    hud.labelText = text;
}

+ (void)hideWait {
    [MBProgressHUD hideHUDForView:[AppDelegate sharedInstance].window animated:YES];
}

@end
