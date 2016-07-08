//
//  LeaveMessage.h
//  jianfanjia
//
//  Created by Karos on 15/11/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface LeaveComment : BaseRequest

@property (strong, nonatomic) NSString *topicid;
@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSString *item;
@property (strong, nonatomic) NSString *topictype;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *to_designerid;
@property (strong, nonatomic) NSString *to_userid;
@property (strong, nonatomic) NSString *to_commentid;

@end
