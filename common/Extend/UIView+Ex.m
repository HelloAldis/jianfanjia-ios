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

#pragma mark - property
- (UIColor *)bgColor {
    return self.backgroundColor;
}

- (void)setBgColor:(UIColor *)color {
    [self setBackgroundColor:color];
}

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

- (UIView *)getFirstSubview:(Class)aClass {
    if ([self isKindOfClass:aClass]) {
        return self;
    }
    
    for (UIView *view in self.subviews) {
        id subview = [view getFirstSubview:[view class]];
        if (subview) {
            return subview;
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

#pragma mark - rotation animation 
- (void)playRotationZAnimation:(CGFloat)duration angle:(CGFloat)angle completion:(void(^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:angle];
    rotateAnimation.repeatCount = 1;
    rotateAnimation.duration = duration;
    [self.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    
    [CATransaction commit];
}

#pragma mark - snapshot
- (UIImage *)snapshotImage {
    return [self snapshotImageAtFrame:self.bounds afterUpdates:NO];
}

- (UIImage *)snapshotImage:(BOOL)afterUpdates {
    return [self snapshotImageAtFrame:self.bounds afterUpdates:afterUpdates];
}

- (UIImage *)snapshotImageAtFrame:(CGRect)r {
    return [self snapshotImageAtFrame:r afterUpdates:NO];
}

//获得某个范围内的屏幕图像
- (UIImage *)snapshotImageAtFrame:(CGRect)r afterUpdates:(BOOL)afterUpdates {
    if (afterUpdates) {
        UIGraphicsBeginImageContextWithOptions(r.size, self.opaque, [UIScreen mainScreen].scale);
        [self drawViewHierarchyInRect:CGRectMake(-r.origin.x, -r.origin.y, self.bounds.size.width, self.bounds.size.height) afterScreenUpdates:YES];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap;
    } else {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //now we will position the image, X/Y away from top left corner to get the portion we want
        UIGraphicsBeginImageContext(r.size);
        [snap drawAtPoint:CGPointMake(-r.origin.x, -r.origin.y)];
        snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap;
    }
}

@end
