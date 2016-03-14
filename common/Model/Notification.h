//
//  Notification.h
//  jianfanjia
//
//  Created by Karos on 15/12/11.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Notification : BaseModel

@property (strong, nonatomic) id objectId;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *processid;
@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSString *cell;
@property (strong, nonatomic) NSNumber *time;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSNumber *badge;

@end