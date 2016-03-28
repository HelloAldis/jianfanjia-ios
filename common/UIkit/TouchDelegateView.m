//
//  PrettyPictureFallsLayout.h
//  jianfanjia
//
//  Created by likaros on 15/12/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TouchDelegateView.h"

@implementation TouchDelegateView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.touchDelegateView && [self pointInside:point withEvent:event]) {
        __block CGPoint newPoint = [self convertPoint:point toView:self.touchDelegateView];
        __block UIView *test = [self.touchDelegateView hitTest:newPoint withEvent:event];
        if (test) {
            return test;
        } else {
            @weakify(self);
            [self.touchDelegateView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self);
                newPoint = [self convertPoint:point toView:obj];
                test = [obj hitTest:newPoint withEvent:event];
                *stop = test != nil;
            }];
            
            return test ? test : self.touchDelegateView;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end