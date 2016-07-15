//
//  UINavigationController+FPS.m
//  jianfanjia
//
//  Created by Karos on 16/7/15.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UINavigationController+FPS.h"

@implementation UINavigationController (FPS)

- (FPSLabel *)fpsLabel {
    return objc_getAssociatedObject(self, @selector(fpsLabel));
}

- (void)setFpsLabel:(FPSLabel *)fpsLabel {
    objc_setAssociatedObject(self, @selector(fpsLabel), fpsLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setupFPS {
#ifdef DEBUG
    self.fpsLabel = [FPSLabel new];
    [self.fpsLabel sizeToFit];
    CGRect frame = self.fpsLabel.frame;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2.0 + frame.size.width;
    frame.origin.y = 0;
    self.fpsLabel.frame = frame;
    [self.view addSubview:self.fpsLabel];
#endif
}

@end
