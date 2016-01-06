//
//  BindPhone.h
//  jianfanjia
//
//  Created by Karos on 16/1/6.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface BindPhone : BaseRequest

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *code;

@end
