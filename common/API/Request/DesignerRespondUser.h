//
//  DesignerRespondUser.h
//  jianfanjia-designer
//
//  Created by Karos on 16/1/21.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface DesignerRespondUser : BaseRequest

@property (nonatomic, strong) NSString *requirementid;
@property (nonatomic, strong) NSNumber *house_check_time;

@end
