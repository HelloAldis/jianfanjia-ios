//
//  DataManager.m
//  jianfanjia
//
//  Created by JYZ on 15/9/6.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()

@end

static DataManager *dataManager;

@implementation DataManager

+ (void)initialize {
    if(!dataManager) {
        dataManager = [[DataManager alloc] init];
    }
}

+ (DataManager *)shared {
    return dataManager;
}

@end
