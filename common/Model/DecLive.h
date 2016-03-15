//
//  Plan.h
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@class DecLiveSection;

@interface DecLive : BaseModel

@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSNumber *lastupdate;
@property(nonatomic, strong) NSNumber *create_at;
@property(nonatomic, strong) NSString *manager;
@property(nonatomic, strong) NSString *province;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *district;
@property(nonatomic, strong) NSString *cell;
@property(nonatomic, strong) NSString *house_type;
@property(nonatomic, strong) NSNumber *house_area;
@property(nonatomic, strong) NSString *dec_style;
@property(nonatomic, strong) NSString *dec_type;
@property(nonatomic, strong) NSString *work_type;
@property(nonatomic, strong) NSNumber *total_price;
@property(nonatomic, strong) NSNumber *start_at;
@property(nonatomic, strong) NSString *cover_imageid;
@property(nonatomic, strong) NSString *designerid;
@property(nonatomic, strong) NSString *declive_description;
@property(nonatomic, strong) NSString *progress;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *view_count;
@property(nonatomic, strong) NSArray *process;

//不动态属性
@property(nonatomic, strong) Designer *designer;
@property(nonatomic, strong) DecLiveSection *curSection;

@end