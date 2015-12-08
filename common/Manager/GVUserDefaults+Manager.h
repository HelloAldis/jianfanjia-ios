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
@property (nonatomic, weak) NSString *processid;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, weak) NSString *phone;
@property (nonatomic, weak) NSString *loginDate;

@end
