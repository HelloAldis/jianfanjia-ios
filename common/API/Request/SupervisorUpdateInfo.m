//
//  UpdateUserInfo.m
//  jianfanjia
//
//  Created by Karos on 15/12/7.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SupervisorUpdateInfo.h"

@interface SupervisorUpdateInfo ()

@property (strong, nonatomic) id supervisor;

@end

@implementation SupervisorUpdateInfo

@dynamic supervisor;

- (id)initWithSupervisor:(Supervisor *)supervisor {
    if (self = [super init]) {
        self.supervisor = supervisor.data;
    }
    
    return self;
}

@end
