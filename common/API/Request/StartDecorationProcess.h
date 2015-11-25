//
//  ConfirmAgreement.h
//  jianfanjia
//
//  Created by Karos on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface StartDecorationProcess : BaseRequest

@property (strong, nonatomic) NSString *requirementid;
@property (strong, nonatomic) NSString *final_planid;

@end
