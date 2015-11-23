//
//  Evaluation.h
//  jianfanjia
//
//  Created by Karos on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Evaluation : BaseModel

@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSString *designerid;
@property(nonatomic, strong) NSString *requirementid;
@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSNumber *respond_speed;
@property(nonatomic, strong) NSNumber *service_attitude;
@property(nonatomic, strong) NSString *comment;

@end
