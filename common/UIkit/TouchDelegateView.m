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
        CGPoint newPoint = [self convertPoint:point toView:self.touchDelegateView];
        UIView *test = [self.touchDelegateView hitTest:newPoint withEvent:event];
        if (test) {
            return test;
        } else {
            return self.touchDelegateView;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end