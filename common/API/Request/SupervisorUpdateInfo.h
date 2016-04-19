//
//  UpdateUserInfo.h
//  jianfanjia
//
//  Created by Karos on 15/12/7.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface SupervisorUpdateInfo : BaseRequest

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *district;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *imageid;

@end
