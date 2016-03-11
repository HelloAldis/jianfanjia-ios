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
+ (void)showLogin;
+ (void)showSignup;
+ (void)showAccountBind;
+ (void)showBindPhone:(BindPhoneEvent)bindPhoneEvent;
+ (void)showVerifyPhone:(VerfityPhoneEvent)verfityPhoneEvent;
+ (void)showResetPass;
+ (void)showCollectDecPhase;
+ (void)showCollectDecStyle;
+ (void)showCollectFamilyInfo;
+ (void)showSearch;
+ (void)showDesignerList;
+ (void)showProductCaseList;
+ (void)showBeautifulImage;
+ (void)showProcessPreview;
+ (void)showProcess:(NSString *)processid;
+ (void)showProduct:(NSString *)productid;
+ (void)showProduct:(NSString *)productid isModal:(BOOL)isModal;
+ (void)showRequirementCreate:(Requirement *)requirement;
+ (void)showDesigner:(NSString *)designerid;
+ (void)showOrderDesigner:(Requirement *)requirement;
+ (void)showReplaceOrderedDesigner:(NSString *)designerid forRequirement:(Requirement *)requirement;
+ (void)showOrderedDesigner:(Requirement *)requirement;
+ (void)showEvaluateDesigner:(Designer *)designer withRequirement:(NSString *)requirementid;
+ (void)showAgreement:(Requirement *)requirement;
+ (void)showPlanList:(NSString *)designerid forRequirement:(Requirement *)requirement;
+ (void)leaveMessage:(Plan *)plan;
+ (void)leaveMessage:(NSString *)processid designer:(NSString *)designerid section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock;
+ (void)showPlanPerview:(Plan *)plan withOrder:(NSInteger)order forRequirement:(Requirement *)requirement;
+ (void)showPlanPriceDetail:(Plan *)plan;
+ (void)showTab;
+ (void)showDBYS:(Section *)section process:(NSString *)processid refresh:(void(^)(void))refreshBlock;
+ (void)showMyNotification;
+ (void)showNotificationDetail:(NSString *)notificationid;
+ (void)showMyComments;
+ (void)showOfflineImages:(NSArray *)offlineImages index:(NSInteger)index;
+ (void)showOnlineImages:(NSArray *)onlineImages index:(NSInteger)index;
+ (void)showRefresh;
+ (void)refreshSuccess;
+ (UIViewController *)getCurrentTapController;
+ (void)logout;

@end
