//
//  CALayer+Ex.h
//  jianfanjia
//
//  Created by Karos on 16/2/24.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Ex)

+ (CALayer *)createMask:(CGRect)frame withTransparentHole:(CGRect)hole;
+ (CALayer *)createMask:(CGRect)frame;
+ (CALayer *)createLayer:(CGRect)frame image:(UIImage *)img;
+ (CALayer *)createRoundBottomLayer:(CGRect)frame cornerRadii:(CGSize)cornerRadii;

- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;
- (void)removePreviousFadeAnimation;

@end
