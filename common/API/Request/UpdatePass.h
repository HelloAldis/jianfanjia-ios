//
//  UpdatePass.h
//  jianfanjia
//
//  Created by JYZ on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface UpdatePass : BaseRequest

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *pass;
@property (strong, nonatomic) NSString *code;

@end
