//
//  GetRequirementPlans.h
//  jianfanjia
//
//  Created by Karos on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface GetRequirementPlans : BaseRequest

@property (strong, nonatomic) NSString *requirementid;
@property (strong, nonatomic) NSString *designerid;

@end
