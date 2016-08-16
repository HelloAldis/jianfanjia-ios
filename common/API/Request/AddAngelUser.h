//
//  AddAngelUser.h
//  jianfanjia
//
//  Created by Karos on 16/8/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

extern NSString * const kAngelUserDistrictRequirement;
extern NSString * const kAngelUserDistrictDesigner;

@interface AddAngelUser : BaseRequest

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *designerid;

@end
