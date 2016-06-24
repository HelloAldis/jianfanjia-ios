//
//  UIScrollView+Ex.m
//  jianfanjia
//
//  Created by Karos on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UIScrollView+Ex.h"

@implementation UIScrollView (Ex)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        MethodSwizzle([self class],
//                         @selector(touchesBegan:withEvent:),
//                         @selector(custom_touchesBegan:withEvent:));
//        MethodSwizzle([self class],
//                      @selector(touchesMoved:withEvent:),
//                      @selector(custom_touchesMoved:withEvent:));
//        MethodSwizzle([self class],
//                      @selector(touchesEnded:withEvent:),
//                      @selector(custom_touchesEnded:withEvent:));
//    });
//}
//
//
//- (BOOL)isSendEventToNextRespnder {
//    return [objc_getAssociatedObject(self, _cmd) boolValue];
//}
//
//- (void)setIsSendEventToNextRespnder:(BOOL)isSend {
//    objc_setAssociatedObject(self, @selector(isSendEventToNextRespnder), @(isSend), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)custom_touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([self isSendEventToNextRespnder]) {
//        [[self nextResponder] touchesBegan:touches withEvent:event];
//    }
//    
//    [self custom_touchesBegan:touches withEvent:event];
//}
//
//-(void)custom_touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([self isSendEventToNextRespnder]) {
//        [[self nextResponder] touchesMoved:touches withEvent:event];
//    }
//    
//    [self custom_touchesMoved:touches withEvent:event];
//}
//
//- (void)custom_touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([self isSendEventToNextRespnder]) {
//        [[self nextResponder] touchesEnded:touches withEvent:event];
//    }
//    
//    [self custom_touchesMoved:touches withEvent:event];
//}

@end
