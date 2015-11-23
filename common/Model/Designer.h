//
//  Designer.h
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"
@class Product;
@class Plan;
@class Requirement;
@class Evaluation;

@interface Designer : BaseModel

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
@property(nonatomic, strong) NSNumber *view_count;
@property(nonatomic, strong) NSNumber *authed_product_count;
@property(nonatomic, strong) NSNumber *order_count;
@property(nonatomic, strong) NSArray *dec_types;
@property(nonatomic, strong) NSArray *dec_house_types;
@property(nonatomic, strong) NSArray *dec_districts;
@property(nonatomic, strong) NSArray *dec_styles;
@property(nonatomic, strong) NSString *philosophy;
@property(nonatomic, strong) NSString *achievement;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSNumber *team_count;
@property(nonatomic, strong) NSString *design_fee_range;
@property(nonatomic, strong) NSNumber *is_my_favorite;
@property(nonatomic, strong) NSNumber *service_attitude;
@property(nonatomic, strong) NSNumber *respond_speed;
@property(nonatomic, strong) NSString *auth_type;
@property(nonatomic, strong) NSNumber *match;

//不动态的属性
@property(nonatomic, strong) Product *product;
//不动态属性
@property(nonatomic, strong) Plan *plan;
//不动态属性
@property(nonatomic, strong) Requirement *requirement;
//不动态属性
@property(nonatomic, strong) Evaluation *evaluation;

@end
