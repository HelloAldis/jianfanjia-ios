//
//  DesignerRejectUser.h
//  jianfanjia-designer
//
//  Created by Karos on 16/1/21.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface DesignerRejectUser : BaseRequest

@property (nonatomic, strong) NSString *requirementid;
@property (nonatomic, strong) NSString *reject_respond_msg;

@end
