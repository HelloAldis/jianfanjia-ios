//
//  UserGetInfo.m
//  jianfanjia
//
//  Created by JYZ on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SupervisorGetInfo.h"

@implementation SupervisorGetInfo

- (void)success {
    NSMutableDictionary *dict = [DataManager shared].data;
    Supervisor *supervisor = [[Supervisor alloc] initWith:dict];
    [GVUserDefaults standardUserDefaults].userid = [supervisor _id];
    [GVUserDefaults standardUserDefaults].imageid = [supervisor imageid];
    [GVUserDefaults standardUserDefaults].username = [supervisor username];
    [GVUserDefaults standardUserDefaults].sex = [supervisor sex];
    [GVUserDefaults standardUserDefaults].province = [supervisor province];
    [GVUserDefaults standardUserDefaults].city = [supervisor city];
    [GVUserDefaults standardUserDefaults].district = [supervisor district];
    [GVUserDefaults standardUserDefaults].address = [supervisor address];
    [GVUserDefaults standardUserDefaults].phone = [supervisor phone];
}

@end
