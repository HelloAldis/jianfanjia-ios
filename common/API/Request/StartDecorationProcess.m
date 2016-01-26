//
//  ConfirmAgreement.m
//  jianfanjia
//
//  Created by Karos on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "StartDecorationProcess.h"

@implementation StartDecorationProcess

@dynamic requirementid;
@dynamic final_planid;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
