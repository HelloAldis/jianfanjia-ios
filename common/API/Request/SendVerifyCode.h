//
//  SendVerifyCode.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface SendVerifyCode : BaseRequest

@property (strong, nonatomic) NSString *phone;

@end
