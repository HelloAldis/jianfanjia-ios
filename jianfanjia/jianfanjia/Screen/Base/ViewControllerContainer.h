//
//  ViewControllerContainer.h
//  AURA
//
//  Created by Aldis on 14-9-30.
//  Copyright (c) 2014年 AURA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ViewControllerContainer : NSObject

+ (void)showAfterLanching;
+ (void)showWelcome;
+ (void)showLogin;
+ (void)showSignup;
+ (void)showAccountBind;
+ (void)showBindPhone:(BindPhoneEvent)bindPhoneEvent callback:(void(^)(void))callback;
+ (void)showVerifyPhone:(VerfityPhoneEvent)verfityPhoneEvent callback:(void(^)(void))callback;
+ (void)showResetPass;
+ (void)showCollectDecPhase;
+ (void)showCollectDecStyle;
+ (void)showCollectFamilyInfo;
+ (void)showSearch;
+ (void)showDesignerList;
+ (void)showProductCaseList;
+ (void)showDecLiveList;
+ (void)showBeautifulImage;
+ (void)showProcessPreview;
+ (void)showProcess:(NSString *)processid;
+ (void)showProduct:(NSString *)productid;
+ (void)showProduct:(NSString *)productid isModal:(BOOL)isModal;
+ (void)showRequirementList;
+ (void)showRequirementCreate:(Requirement *)requirement;
+ (void)showDesigner:(NSString *)designerid;
+ (void)showOrderDesigner:(Requirement *)requirement;
+ (void)showReplaceOrderedDesigner:(NSString *)designerid forRequirement:(Requirement *)requirement;
+ (void)showOrderedDesigner:(Requirement *)requirement;
+ (void)showEvaluateDesigner:(Designer *)designer withRequirement:(NSString *)requirementid;
+ (void)showAgreement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock;
+ (void)showPlanList:(NSString *)designerid forRequirement:(Requirement *)requirement;
+ (void)leaveMessage:(Plan *)plan;
+ (void)leaveMessage:(Process *)process section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock;
+ (void)showPlanPerview:(Plan *)plan forRequirement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock;
+ (void)showPlanPriceDetail:(Plan *)plan requirement:(Requirement *)requirement;
+ (void)showTab;
+ (void)showDBYS:(Section *)section process:(NSString *)processid popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock;
+ (void)showMyNotification;
+ (void)showNotificationDetail:(NSString *)notificationid readBlock:(NotificationReadBlock)readBlock;
+ (void)showMyComments;
+ (void)showOfflineImages:(NSArray *)offlineImages index:(NSInteger)index;
+ (void)showOnlineImages:(NSArray *)onlineImages index:(NSInteger)index;
+ (void)showRefresh;
+ (void)refreshSuccess;
+ (UIViewController *)getCurrentTapController;
+ (void)logout;

@end
