//
//  SnsAccountInfo.h
//  jianfanjia
//
//  Created by Karos on 16/1/6.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface SnsAccountInfo : BaseModel

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 用户在微博的id号
 */
@property (nonatomic, copy) NSString *usid;

/**
 用户微博头像的url
 */
@property (nonatomic, copy) NSString *iconURL;

/**
 微信授权完成后得到的unionId
 
 */
@property (nonatomic, copy) NSString *unionId;

/**
 性别
 
 */
@property (nonatomic, copy) NSString *gender;

@end
