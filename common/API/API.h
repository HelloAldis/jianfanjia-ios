//
//  API.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

extern NSString * const kApiUrl;

@interface API : NSObject

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)userLogin:(UserLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getUserRequirement:(GetUserRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)sendAddRequirement:(SendAddRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getOrderableDesigners:(GetOrderableDesigners *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)orderDesigner:(OrderDesignder *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getProcessList:(ProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)homePageDesigners:(HomePageDesigners *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)productHomePage:(ProductHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)designerHomePage:(DesignerHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)queryProduct:(QueryProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)verifyPhone:(VerifyPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)userSignup:(UserSignup *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)updatePass:(UpdatePass *)request success:(void (^)(void))success failure:(void (^)(void))failure;

@end
