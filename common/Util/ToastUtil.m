//
//  ToastUtil.m
//  jianfanjia
//
//  Created by Karos on 16/4/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ToastUtil.h"
#import <CRToast/CRToast.h>

@implementation ToastUtil

+ (void)showNotification:(Notification *)notification tapBlock:(ToastTapBlock)tapBlock {
    NSMutableDictionary *options = [self options:notification.content];
    [self setAction:notification tapBlock:tapBlock options:options];
    
    [CRToastManager showNotificationWithOptions:options
                                 apperanceBlock:nil
                                completionBlock:nil];
}

+ (NSMutableDictionary *)options:(NSString *)content {
    NSMutableDictionary *options = [@{kCRToastNotificationTypeKey               : @(CRToastTypeNavigationBar),
                                      kCRToastNotificationPresentationTypeKey   : @(CRToastPresentationTypeCover),
                                      kCRToastUnderStatusBarKey                 : @(NO),
                                      kCRToastTextKey                           : content,
                                      kCRToastTextAlignmentKey                  : @(NSTextAlignmentLeft),
                                      kCRToastTimeIntervalKey                   : @1,
                                      kCRToastAnimationInTypeKey                : @0,
                                      kCRToastAnimationOutTypeKey               : @0,
                                      kCRToastAnimationInDirectionKey           : @0,
                                      kCRToastAnimationOutDirectionKey          : @0,
                                      kCRToastNotificationPreferredPaddingKey   : @0,
                                      kCRToastImageAlignmentKey                 : @(CRToastAccessoryViewAlignmentLeft),
                                      kCRToastIdentifierKey                     : content,
                                      kCRToastSubtitleTextKey                   : content,
                                      kCRToastSubtitleTextAlignmentKey          : @(NSTextAlignmentLeft)} mutableCopy];
    
    return options;
}

+ (void)setAction:(Notification *)notification tapBlock:(ToastTapBlock)tapBlock options:(NSMutableDictionary *)options {
    NSMutableDictionary *data = notification.data;
    options[kCRToastInteractionRespondersKey] = @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                  automaticallyDismiss:YES
                                                                                                                 block:^(CRToastInteractionType interactionType){
                                                                                                                     if (tapBlock) {
                                                                                                                         tapBlock(data);
                                                                                                                     }
                                                                                                                 }]];
}

@end
