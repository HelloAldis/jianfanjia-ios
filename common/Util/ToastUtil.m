//
//  ToastUtil.m
//  jianfanjia
//
//  Created by Karos on 16/4/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ToastUtil.h"
#import <CRToast/CRToast.h>

NSString *const kToastDataKey = @"kToastDataKey";

@implementation ToastUtil

+ (void)showNotification:(Notification *)notification tapBlock:(ToastTapBlock)tapBlock {
    NSMutableDictionary *options = [self options:notification.content data:notification.data];
    [self setAction:options tapBlock:tapBlock];
    
    [CRToastManager showNotificationWithOptions:options apperanceBlock:nil completionBlock:nil];
}

+ (NSMutableDictionary *)options:(NSString *)title data:(NSMutableDictionary *)data {
    const CGRect frame = CGRectMake(0, 0, kScreenWidth, kNavWithStatusBarHeight);
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = frame;
    effectview.userInteractionEnabled = NO;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.contentMode = UIViewContentModeScaleToFill;
    [imgView addSubview:effectview];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    imgView.image = [window snapshotImageAtFrame:frame];

    NSMutableDictionary *options = [@{kCRToastNotificationTypeKey               : @(CRToastTypeNavigationBar),
                                      kCRToastNotificationPresentationTypeKey   : @(CRToastPresentationTypeCover),
                                      kCRToastUnderStatusBarKey                 : @(NO),
                                      kCRToastBackgroundColorKey                : [UIColor clearColor],
                                      kCRToastBackgroundViewKey                 : imgView,
                                      kCRToastTextKey                           : @"您有一条新消息，点击查看详情",
                                      kCRToastFontKey                           : [UIFont systemFontOfSize:13],
                                      kCRToastTextColorKey                      : [UIColor lightGrayColor],
                                      kCRToastTextAlignmentKey                  : @(NSTextAlignmentLeft),
                                      kCRToastTimeIntervalKey                   : @4,
                                      kCRToastAnimationInTypeKey                : @0,
                                      kCRToastAnimationOutTypeKey               : @0,
                                      kCRToastAnimationInDirectionKey           : @0,
                                      kCRToastAnimationOutDirectionKey          : @0,
                                      kCRToastNotificationPreferredPaddingKey   : @3,
                                      kCRToastImageAlignmentKey                 : @(CRToastAccessoryViewAlignmentLeft),
                                      kToastDataKey                             : data,
                                      kCRToastSubtitleTextKey                   : title,
                                      kCRToastSubtitleFontKey                   : [UIFont systemFontOfSize:14],
                                      kCRToastSubtitleTextColorKey              : [UIColor whiteColor],
                                      kCRToastSubtitleTextAlignmentKey          : @(NSTextAlignmentLeft),
                                      kCRToastSubtitleTextMaxNumberOfLinesKey   : @2
                                      } mutableCopy];

    return options;
}

+ (void)setAction:(NSMutableDictionary *)options tapBlock:(ToastTapBlock)tapBlock {
    NSMutableDictionary *data = options[kToastDataKey];
    options[kCRToastInteractionRespondersKey] = @[[CRToastInteractionResponder
                                                   interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                      automaticallyDismiss:NO
                                                                                     block:^(CRToastInteractionType interactionType){
                                                                                         [CRToastManager dismissNotification:YES];
                                                                                         if (tapBlock) {
                                                                                             tapBlock(data);
                                                                                         }
                                                                                     }],
                                                  [CRToastInteractionResponder
                                                   interactionResponderWithInteractionType:CRToastInteractionTypeSwipe
                                                   automaticallyDismiss:YES
                                                   block:^(CRToastInteractionType interactionType){
                                                       [CRToastManager dismissNotification:NO];
                                                   }]
                                                  ];
    
}

@end
