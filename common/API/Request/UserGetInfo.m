//
//  UserGetInfo.m
//  jianfanjia
//
//  Created by JYZ on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UserGetInfo.h"

@implementation UserGetInfo

- (void)success {
    NSMutableDictionary *dict = [DataManager shared].data;
    User *user = [[User alloc] initWith:dict];
    [GVUserDefaults standardUserDefaults].userid = [user _id];
    [GVUserDefaults standardUserDefaults].imageid = [user imageid];
    [GVUserDefaults standardUserDefaults].username = [user username];
    [GVUserDefaults standardUserDefaults].sex = [user sex];
    [GVUserDefaults standardUserDefaults].province = [user province];
    [GVUserDefaults standardUserDefaults].city = [user city];
    [GVUserDefaults standardUserDefaults].district = [user district];
    [GVUserDefaults standardUserDefaults].address = [user address];
    [GVUserDefaults standardUserDefaults].dec_progress = [user dec_progress];
    [GVUserDefaults standardUserDefaults].dec_styles = [user dec_styles];
    [GVUserDefaults standardUserDefaults].family_description = [user family_description];
}

@end
