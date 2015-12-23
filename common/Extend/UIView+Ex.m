//
//  UIView+Util.m
//  AURA
//
//  Created by KindAzrael on 15/3/8.
//  Copyright (c) 2015年 AURA. All rights reserved.
//

#import "UIView+Ex.h"

NSString const *UIView_TapBlock = @"UIView_TapBlock";

@implementation UIView (Ex)

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setBorder:(CGFloat)width andColor:(CGColorRef)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color;
}

- (UIView *)getFirstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *view in self.subviews) {
        id responder = [view getFirstResponder];
        if (responder) {
            return responder;
        }
    }
    
    return nil;
}

#pragma mark - tap animation

- (void)addTapBounceAnimation:(TapBlock)tapBlock {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBounceAnimation)];
    [self addGestureRecognizer:tap];
    self.tapBlock = tapBlock;
}

- (void)playBounceAnimation {
    CAKeyframeAnimation *bounceAnimation = [[CAKeyframeAnimation alloc] init];
    bounceAnimation.keyPath = @"transform.scale";
    bounceAnimation.values = @[@1.0 ,@1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = 0.5;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:bounceAnimation forKey:@"BounceAnimation"];
    
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (TapBlock)tapBlock {
    return objc_getAssociatedObject(self, &UIView_TapBlock);
}

- (void)setTapBlock:(TapBlock)tapBlock {
    objc_setAssociatedObject(self, &UIView_TapBlock, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
