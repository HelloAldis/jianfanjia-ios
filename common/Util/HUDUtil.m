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

+ (void)showErrText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:1.5];
}

+ (void)showSuccessText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:1.5];
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
