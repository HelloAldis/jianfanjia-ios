//
//  UserNotification.h
//  jianfanjia
//
//  Created by Karos on 16/3/9.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface UserNotification : BaseModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *message_type;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *create_at;
@property (nonatomic, strong) NSNumber *lastupdate;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *designerid;
@property (nonatomic, strong) NSString *planid;
@property (nonatomic, strong) NSString *requirementid;

@end
