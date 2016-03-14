
//
//  UIButton+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "UIButton+Ex.h"
#import "API.h"

@implementation UIButton (Ex)

- (void)setDisableAlpha {
    self.alpha = 0.4;
}

- (void)setEnableAlpha {
    self.alpha = 1;
}

- (void)disable {
    [self disable:nil];
}

- (void)disable:(NSString *)text {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundColor:kUntriggeredColor];
    if (text) {
        [self setTitle:text forState:UIControlStateNormal];
    }

    [self setEnabled:NO];
}

@end
