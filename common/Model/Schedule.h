//
//  Reschedule.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Schedule : BaseModel

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSNumber *request_date;
@property (strong, nonatomic) NSString *processid;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *designerid;
@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSNumber *updated_date;
@property (strong, nonatomic) NSString *request_role;
@property (strong, nonatomic) NSString *status;

//不动态的属性
@property (strong, nonatomic) Process *process;

@end
