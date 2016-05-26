//
//  Designer.h
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Team : BaseModel

@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSString *designerid;
@property(nonatomic, strong) NSString *manager;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSNumber *work_year;
@property(nonatomic, strong) NSString *good_at;
@property(nonatomic, strong) NSString *working_on;
@property(nonatomic, strong) NSString *sex;
@property(nonatomic, strong) NSString *province;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *district;
@property(nonatomic, strong) NSNumber *create_at;
@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *uid_image1;
@property(nonatomic, strong) NSString *uid_image2;

@end
