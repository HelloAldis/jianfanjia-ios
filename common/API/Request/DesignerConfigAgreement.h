//
//  DesignerConfigAgreement.h
//  jianfanjia-designer
//
//  Created by Karos on 16/1/22.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface DesignerConfigAgreement : BaseRequest

@property (nonatomic, strong) NSString *requirementid;
@property (nonatomic, strong) NSNumber *start_at;
@property (nonatomic, strong) NSString *manager;

@end
