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

+ (UINavigationController *)navigation;
+ (void)showAfterLanching;
+ (void)showLogin;
+ (void)showSignup;
+ (void)showVerifyPhone:(VerfityPhoneEvent)verfityPhoneEvent;
+ (void)showResetPass;
+ (void)showProcessPreview;
+ (void)showProcess:(NSString *)processid;
+ (void)showProduct:(NSString *)productid;
+ (void)showProduct:(NSString *)productid isModal:(BOOL)isModal;
+ (void)showRequirementCreate:(Requirement *)requirement;
+ (void)showEvaluate:(Designer *)designer evaluation:(Evaluation *)evaluation;
+ (void)showPlanList:(Requirement *)requirement;
+ (void)leaveMessage:(Plan *)plan;
+ (void)leaveMessage:(Process *)process section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock;
+ (void)showPlanPerview:(Plan *)plan forRequirement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock;
+ (void)showPlanPriceDetail:(Plan *)plan requirement:(Requirement *)requirement;
+ (void)showTab;
+ (void)showDBYS:(Section *)section process:(NSString *)processid refresh:(void(^)(void))refreshBlock;
+ (void)showMyNotification:(NotificationType)displayType;
+ (void)showNotificationDetail:(NSString *)notificationid readBlock:(NotificationReadBlock)readBlock;
+ (void)showMyComments;
+ (void)showDesignerAuth;
+ (void)showInfoAuth:(Designer *)designer canEdit:(BOOL)canEdit;
+ (void)showIDAuth:(Designer *)designer;
+ (void)showServiceArea:(Designer *)designer;
+ (void)showProductAuth;
+ (void)showProductAuthUploadPart1:(Product *)product;
+ (void)showProductAuthUploadPart2:(Product *)product;
+ (void)showTeamAuth;
+ (void)showTeamAuthUpdate:(Team *)team;
+ (void)showTeamConfigure:(Requirement *)requirement startTime:(NSNumber *)startTime completion:(void (^)(BOOL completion))completion;
+ (void)showEmailAuthRequest:(Designer *)designer;
+ (void)showEmailAuthReviewing:(Designer *)designer;
+ (void)showEmailAuthSuccess:(Designer *)designer;
+ (void)showUserLicense:(Designer *)designer fromRegister:(BOOL)fromRegister;
+ (void)showOfflineImages:(NSArray *)offlineImages index:(NSInteger)index;
+ (void)showOnlineImages:(NSArray *)onlineImages index:(NSInteger)index;
+ (void)showRefresh;
+ (void)refreshSuccess;
+ (UIViewController *)getCurrentTapController;
+ (UIViewController *)getCurrentTopController;
+ (void)logout;

@end
