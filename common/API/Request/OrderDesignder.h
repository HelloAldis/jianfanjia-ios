//
//  OrderDesignder.h
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface OrderDesignder : BaseRequest

@property (strong, nonatomic) NSString *requirementid;
@property (strong, nonatomic) NSArray *designerids;

@end
