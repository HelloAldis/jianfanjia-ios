//
//  UIViewController+KeyboardAnimation.m
//  jianfanjia
//
//  Created by Karos on 16/4/28.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UIViewController+KeyboardAnimation.h"

static void *JFJAnimationsBlockAssociationKey = &JFJAnimationsBlockAssociationKey;
static void *JFJBeforeAnimationsBlockAssociationKey = &JFJBeforeAnimationsBlockAssociationKey;
static void *JFJAnimationsCompletionBlockAssociationKey = &JFJAnimationsCompletionBlockAssociationKey;

@implementation UIViewController (KeyboardAnimation)

- (void)jfj_subscribeKeyboardWithAnimations:(JFJAnimationsWithKeyboardBlock)animations
                                completion:(JFJCompletionKeyboardAnimations)completion {
    [self jfj_subscribeKeyboardWithBeforeAnimations:nil animations:animations completion:completion];
}

- (void)jfj_subscribeKeyboardWithBeforeAnimations:(JFJBeforeAnimationsWithKeyboardBlock)beforeAnimations
                                      animations:(JFJAnimationsWithKeyboardBlock)animations
                                      completion:(JFJCompletionKeyboardAnimations)completion {
    // we shouldn't check for nil because it does nothing with nil
    objc_setAssociatedObject(self, JFJBeforeAnimationsBlockAssociationKey, beforeAnimations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, JFJAnimationsBlockAssociationKey, animations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, JFJAnimationsCompletionBlockAssociationKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // subscribe to keyboard animations
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jfj_handleWillShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jfj_handleWillHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)jfj_unsubscribeKeyboard {
    // unsubscribe from keyboard animations
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)jfj_handleWillShowKeyboardNotification:(NSNotification *)notification {
    [self jfj_animationWithKeyboardOption:notification isShowing:YES];
}

- (void)jfj_handleWillHideKeyboardNotification:(NSNotification *)notification {
    [self jfj_animationWithKeyboardOption:notification isShowing:NO];
}

- (void)jfj_animationWithKeyboardOption:(NSNotification *)notification isShowing:(BOOL)isShowing {
    // getting keyboard animation attributes
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    DDLogDebug(@"animationCurve: %@",@(animationCurve));
//    DDLogDebug(@"duration: %@",@(duration));
    
    // getting passed blocks
    JFJAnimationsWithKeyboardBlock animationsBlock = objc_getAssociatedObject(self, JFJAnimationsBlockAssociationKey);
    JFJBeforeAnimationsWithKeyboardBlock beforeAnimationsBlock = objc_getAssociatedObject(self, JFJBeforeAnimationsBlockAssociationKey);
    JFJCompletionKeyboardAnimations completionBlock = objc_getAssociatedObject(self, JFJAnimationsCompletionBlockAssociationKey);
    
    if (beforeAnimationsBlock) beforeAnimationsBlock(keyboardRect, isShowing);
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationCurve | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         if (animationsBlock) animationsBlock(keyboardRect, isShowing);
                         [self.view layoutIfNeeded];
                     }
                     completion:completionBlock];
}

@end
