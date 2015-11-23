//
//  Comment.h
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Comment : BaseModel

@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSString *topicid;
@property(nonatomic, strong) NSString *section;
@property(nonatomic, strong) NSString *topictype;
@property(nonatomic, strong) NSString *to;
@property(nonatomic, strong) NSString *by;
@property(nonatomic, strong) NSString *usertype;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSNumber *date;

@end
