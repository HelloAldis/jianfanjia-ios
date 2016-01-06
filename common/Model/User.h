//
//  User.h
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel

@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *sex;
@property(nonatomic, strong) NSString *province;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *district;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *imageid;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *dec_progress;
@property(nonatomic, strong) NSArray *dec_styles;
@property(nonatomic, strong) NSString *family_description;
@property(nonatomic, strong) NSString *wechat_openid;
@property(nonatomic, strong) NSString *wechat_unionid;

@end
