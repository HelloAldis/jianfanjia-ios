//
//  CALayer+Ex.m
//  jianfanjia
//
//  Created by Karos on 16/2/24.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "CALayer+Ex.h"

@implementation CALayer (Ex)

+ (CALayer *)createMask:(CGRect)frame withTransparentHole:(CGRect)hole {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:hole cornerRadius:hole.size.width / 2];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    return [CALayer createMaskWithPath:path];
}

+ (CALayer *)createMask:(CGRect)frame {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:0];
    [path setUsesEvenOddFillRule:YES];
    
    return [CALayer createMaskWithPath:path];
}

+ (CALayer *)createMaskWithPath:(UIBezierPath *)path {
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.7;
    
    return fillLayer;
}

+ (CALayer *)createLayer:(CGRect)frame image:(UIImage *)img {
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.contents = (__bridge id _Nullable)(img.CGImage);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsScale = [UIScreen mainScreen].scale;
    
    return layer;
}

+ (CALayer *)createRoundBottomLayer:(CGRect)frame cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:cornerRadii];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.fillColor = [UIColor whiteColor].CGColor;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    shape.path = path.CGPath;
    shape.frame = frame;
    
    return shape;
}

- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    if (duration <= 0) return;
    
    NSString *mediaFunction;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut: {
            mediaFunction = kCAMediaTimingFunctionEaseInEaseOut;
        } break;
        case UIViewAnimationCurveEaseIn: {
            mediaFunction = kCAMediaTimingFunctionEaseIn;
        } break;
        case UIViewAnimationCurveEaseOut: {
            mediaFunction = kCAMediaTimingFunctionEaseOut;
        } break;
        case UIViewAnimationCurveLinear: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
        default: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:mediaFunction];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:@"yykit.fade"];
}

- (void)removePreviousFadeAnimation {
    [self removeAnimationForKey:@"yykit.fade"];
}

@end
