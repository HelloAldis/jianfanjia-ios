//
//  ChoosePlan.h
//  jianfanjia
//
//  Created by Karos on 15/11/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface ChoosePlan : BaseRequest

@property (strong, nonatomic) NSString *planid;
@property (strong, nonatomic) NSString *designerid;
@property (strong, nonatomic) NSString *requirementid;

@end
