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

+ (void)showText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
}

@end
