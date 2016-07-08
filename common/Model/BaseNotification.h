//
//  UserNotification.h
//  jianfanjia
//
//  Created by Karos on 16/3/9.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface BaseNotification : BaseModel

//不动态属性
@property (nonatomic, strong) Process *process;
@property (nonatomic, strong) Requirement *requirement;
@property (nonatomic, strong) Schedule *schedule;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Designer *designer;
@property (nonatomic, strong) Supervisor *supervisor;
@property (nonatomic, strong) Plan *plan;
@property (nonatomic, strong) Diary *diary;
@property (nonatomic, strong) Comment *toComment;

@end
