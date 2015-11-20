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
+ (void)showVerifyPhone:(BOOL)isResetPass;
+ (void)showSignupSuccess;
+ (void)showResetPass;
+ (void)showProcess;
+ (void)showProduct:(NSString *)productid;
+ (void)showDesigner:(NSString *)designerid;
+ (void)showOrderDesigner:(Requirement *)requirement;
+ (void)showReplaceOrderedDesigner:(NSString *)designerid forRequirement:(Requirement *)requirement;
+ (void)showOrderedDesigner:(Requirement *)requirement;
+ (void)showEvaluateDesigner:(Designer *)designer withRequirement:(NSString *)requirementid;
+ (void)showPlanList:(NSString *)designerid forRequirement:(Requirement *)requirement;
+ (void)showTab;
+ (void)showImageDetail:(NSArray *)images withIndex:(NSInteger)index;
+ (void)showRefresh;
+ (void)refreshSuccess;
+ (void)logout;

@end
