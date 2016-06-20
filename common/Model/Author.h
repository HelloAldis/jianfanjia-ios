//
//  Author.h
//  jianfanjia
//
//  Created by Karos on 16/6/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Author : BaseModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *imageid;

@end
