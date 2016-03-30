//
//  UIView+Util.h
//  AURA
//
//  Created by KindAzrael on 15/3/8.
//  Copyright (c) 2015年 AURA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TapBlock)(void);

@interface UIView (Ex)

- (void)setCornerRadius:(CGFloat)radius;
- (void)setBorder:(CGFloat)width andColor:(CGColorRef)color;
- (UIView *)getFirstResponder;
- (UIView *)getFirstSubview:(Class)aClass;
- (void)addTapBounceAnimation:(TapBlock)tapBlock;
+ (void)playBounceAnimationFor:(UIView *)view completion:(void(^)(void))completion;
+ (void)playBounceAnimationFor:(UIView *)view block:(void(^)(void))block;
- (void)playRotationZAnimation:(CGFloat)duration angle:(CGFloat)angle completion:(void(^)(void))completion;
- (UIImage *)snapshotImage;

@end
