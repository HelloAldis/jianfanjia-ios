//
//  Plan.h
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Plan : BaseModel

@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSString *designerid;
@property(nonatomic, strong) NSString *requirementid;
@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSNumber *house_check_time;
@property(nonatomic, strong) NSNumber *last_status_update_time;
@property(nonatomic, strong) NSNumber *request_date;
@property(nonatomic, strong) NSNumber *project_price_before_discount;
@property(nonatomic, strong) NSNumber *total_design_fee;
@property(nonatomic, strong) NSNumber *project_price_after_discount;
@property(nonatomic, strong) NSNumber *total_price;
@property(nonatomic, strong) NSNumber *duration;
@property(nonatomic, strong) NSString *manager;
@property(nonatomic, strong) NSString *plan_description;
@property(nonatomic, strong) NSNumber *comment_count;
@property(nonatomic, strong) NSArray *images;

//不动态属性
@property(nonatomic, strong) Designer *designer;

@end

