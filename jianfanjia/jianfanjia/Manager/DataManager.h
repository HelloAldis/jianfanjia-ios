//
//  DataManager.h
//  jianfanjia
//
//  Created by JYZ on 15/9/6.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Process.h"

@interface DataManager : NSObject

@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) NSMutableDictionary *response;

@property (nonatomic, strong) NSMutableDictionary *processDict;


+ (DataManager *)shared;

@end
