//
//  GVUserDefaults+Manager.h
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVUserDefaults (Manager)

@property (nonatomic, assign) NSInteger welcomeVersion;
@property (nonatomic, weak) NSString *usertype;
@property (nonatomic, weak) NSString *userid;
@property (nonatomic, weak) NSString *imageid;
@property (nonatomic, weak) NSString *username;
@property (nonatomic, weak) NSString *sex;
@property (nonatomic, weak) NSString *province;
@property (nonatomic, weak) NSString *city;
@property (nonatomic, weak) NSString *district;
@property (nonatomic, weak) NSString *address;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, weak) NSString *phone;
@property (nonatomic, weak) NSString *loginDate;
@property (nonatomic, strong) NSString *dec_progress;
@property (nonatomic, strong) NSNumber *respond_speed;
@property (nonatomic, strong) NSNumber *service_attitude;
@property (nonatomic, strong) NSString *auth_type;
@property (nonatomic, strong) NSArray *dec_styles;
@property (nonatomic, strong) NSString *family_description;
@property (nonatomic, strong) NSString *wechat_openid;
@property (nonatomic, strong) NSString *wechat_unionid;
@property (nonatomic, assign) BOOL wasShowProductCaseUserHelper;
@property (nonatomic, assign) BOOL wasShowProductCaseRightArrow;

@end
