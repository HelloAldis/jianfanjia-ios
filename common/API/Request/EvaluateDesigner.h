//
//  EvaluateDesigner.h
//  jianfanjia
//
//  Created by Karos on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface EvaluateDesigner : BaseRequest

@property (strong, nonatomic) NSString *designerid;
@property (strong, nonatomic) NSString *requirementid;
@property (assign, nonatomic) NSNumber *service_attitude;
@property (assign, nonatomic) NSNumber *respond_speed;
@property (strong, nonatomic) NSString *comment;
@property (assign, nonatomic) NSString *is_anonymous;

@end
