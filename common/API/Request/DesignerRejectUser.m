//
//  DesignerRejectUser.m
//  jianfanjia-designer
//
//  Created by Karos on 16/1/21.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DesignerRejectUser.h"

@implementation DesignerRejectUser

@dynamic requirementid;
@dynamic reject_respond_msg;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
