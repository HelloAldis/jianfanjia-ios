//
//  GetComments.h
//  jianfanjia
//
//  Created by Karos on 15/11/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface GetComments : BaseRequest

@property (strong, nonatomic) NSString *topicid;
@property (assign, nonatomic) NSNumber *from;
@property (assign, nonatomic) NSNumber *limit;


@end
