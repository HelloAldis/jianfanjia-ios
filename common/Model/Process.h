//
//  Process.h
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"
@class Section;
@class User;
@class Plan;
@class Requirement;

@interface Process : BaseModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *final_designerid;
@property (nonatomic, strong) NSString *final_planid;
@property (nonatomic, strong) NSString *requirementid;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *basic_address;
@property (nonatomic, strong) NSString *house_type;
@property (nonatomic, strong) NSNumber *house_area;
@property (nonatomic, strong) NSString *dec_style;
@property (nonatomic, strong) NSString *work_type;
@property (nonatomic, strong) NSNumber *total_price;
@property (nonatomic, strong) NSNumber *start_at;
@property (nonatomic, strong) NSNumber *lastupdate;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSString *going_on;
@property (nonatomic, strong) NSMutableArray *sections;

//不动态的属性
@property(nonatomic, strong) User *user;
//不动态属性
@property(nonatomic, strong) Plan *plan;
//不动态属性
@property(nonatomic, strong) Requirement *requirement;

- (Section *)sectionAtIndex:(NSInteger )index;

@end
