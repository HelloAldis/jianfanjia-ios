//
//  BaseViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/5.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self.view endEditing:YES];
}

@end
