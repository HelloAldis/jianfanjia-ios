//
//  UIViewController+KeyboardAnimation.h
//  jianfanjia
//
//  Created by Karos on 16/4/28.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (KeyboardAnimation)

typedef void(^JFJAnimationsWithKeyboardBlock)(CGRect keyboardRect, BOOL isShowing);
typedef void(^JFJBeforeAnimationsWithKeyboardBlock)(CGRect keyboardRect, BOOL isShowing);
typedef void(^JFJCompletionKeyboardAnimations)(BOOL finished);

- (void)jfj_subscribeKeyboardWithAnimations:(JFJAnimationsWithKeyboardBlock)animations
                                 completion:(JFJCompletionKeyboardAnimations)completion;

- (void)jfj_subscribeKeyboardWithBeforeAnimations:(JFJBeforeAnimationsWithKeyboardBlock)beforeAnimations
                                       animations:(JFJAnimationsWithKeyboardBlock)animations
                                       completion:(JFJCompletionKeyboardAnimations)completion;

- (void)jfj_unsubscribeKeyboard;

@end
