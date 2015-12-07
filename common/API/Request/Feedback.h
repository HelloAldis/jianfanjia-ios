//
//  Feedback.h
//  jianfanjia
//
//  Created by JYZ on 15/12/7.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface Feedback : BaseRequest

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *platform;
@property (strong, nonatomic) NSString *version;

@end