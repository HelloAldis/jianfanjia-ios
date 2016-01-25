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
+ (void)showVerifyPhone:(VerfityPhoneEvent)verfityPhoneEvent;
+ (void)showResetPass;
+ (void)showProcessPreview;
+ (void)showProcess:(NSString *)processid;
+ (void)showProduct:(NSString *)productid;
+ (void)showRequirementCreate:(Requirement *)requirement;
//+ (void)showDesigner:(NSString *)designerid;
+ (void)showEvaluate:(Evaluation *)evaluation;
+ (void)showPlanList:(Requirement *)requirement;
+ (void)leaveMessage:(Plan *)plan;
+ (void)leaveMessage:(NSString *)processid section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock;
+ (void)showPlanPerview:(Plan *)plan withOrder:(NSInteger)order forRequirement:(Requirement *)requirement;
+ (void)showPlanPriceDetail:(Plan *)plan;
+ (void)showTab;
+ (void)showDBYS:(Section *)section process:(NSString *)processid refresh:(void(^)(void))refreshBlock;
+ (void)showReminder:(NSString *)processid refreshBlock:(void(^)(NSString *type))refreshBlock;
+ (void)showOfflineImages:(NSArray *)offlineImages index:(NSInteger)index;
+ (void)showOnlineImages:(NSArray *)onlineImages index:(NSInteger)index;
+ (void)showRefresh;
+ (void)refreshSuccess;
+ (UIViewController *)getCurrentTapController;
+ (void)logout;

@end
