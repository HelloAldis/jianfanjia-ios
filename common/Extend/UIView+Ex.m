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

+ (void)playBounceAnimationFor:(UIView *)view completion:(void(^)(void))completion {
    [self playBounceAnimationFor:view isWaiteDone:YES block:completion];
}

+ (void)playBounceAnimationFor:(UIView *)view block:(void(^)(void))block {
    [self playBounceAnimationFor:view isWaiteDone:YES block:block];
}

+ (void)playBounceAnimationFor:(UIView *)view isWaiteDone:(BOOL)isWaiteDone block:(void(^)(void))block {
    [CATransaction begin];
    if (isWaiteDone) {
        [CATransaction setCompletionBlock:block];
    }
    
    CAKeyframeAnimation *bounceAnimation = [[CAKeyframeAnimation alloc] init];
    bounceAnimation.keyPath = @"transform.scale";
    bounceAnimation.values = @[@1.0 ,@1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = 0.5;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [view.layer addAnimation:bounceAnimation forKey:@"BounceAnimation"];
    
    [CATransaction commit];
    
    if (!isWaiteDone) {
        if (block) {
            block();
        }
    }
}

- (void)addTapBounceAnimation:(TapBlock)tapBlock {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBounceAnimation)];
    [self addGestureRecognizer:tap];
    self.tapBlock = tapBlock;
}

- (void)playBounceAnimation {
    [UIView playBounceAnimationFor:self block:self.tapBlock];
}

- (TapBlock)tapBlock {
    return objc_getAssociatedObject(self, &UIView_TapBlock);
}

- (void)setTapBlock:(TapBlock)tapBlock {
    objc_setAssociatedObject(self, &UIView_TapBlock, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
