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
+ (void)showRequirementCreate:(Requirement *)requirement;
+ (void)leaveMessage:(Plan *)plan;
+ (void)leaveMessage:(Process *)process section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock;
+ (void)showPlanPerview:(Plan *)plan forRequirement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock;
+ (void)showPlanPriceDetail:(Plan *)plan requirement:(Requirement *)requirement;
+ (void)showTab;
+ (void)showDBYS:(Section *)section process:(NSString *)processid refresh:(void(^)(void))refreshBlock;
+ (void)showOfflineImages:(NSArray *)offlineImages fromImageView:(UIView *)imageView index:(NSInteger)index;
+ (void)showOnlineImages:(NSArray *)onlineImages fromImageView:(UIView *)imageView index:(NSInteger)index;
+ (void)showPhotoView:(NSArray<PhotoGroupItem *> *)items fromImageView:(UIView *)imageView index:(NSInteger)index;
+ (void)showRefresh;
+ (void)refreshSuccess;
+ (UIViewController *)getCurrentTapController;
+ (UIViewController *)getCurrentTopController;
+ (void)logout;

@end
