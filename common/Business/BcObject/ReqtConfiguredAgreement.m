//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReqtConfiguredAgreement.h"

@implementation ReqtConfiguredAgreement

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kRequirementStatusConfiguredAgreementWithoutWorkSite action:action];
}

@end
