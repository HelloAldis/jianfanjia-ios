//
//  Login.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface DesignerLogin : BaseRequest

@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *pass;

@end
