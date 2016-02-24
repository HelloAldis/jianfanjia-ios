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

+ (CALayer *)createLayer:(UIImage *)img {
    CALayer *layer = [CALayer layer];
    layer.contents = (__bridge id _Nullable)(img.CGImage);
    
    return layer;
}

@end
