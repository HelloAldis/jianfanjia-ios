//
//  BaseSelectionViewController.m
//  jianfanjia
//
//  Created by likaros on 15/12/6.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseSelectionViewController.h"

@interface BaseSelectionViewController ()

@end

@implementation BaseSelectionViewController

- (id)initWithValueBlock:(ValueBlock)ValueBlock curValue:(NSString *)curValue {
    if (self = [super init]) {
        _ValueBlock = ValueBlock;
        _curValue = curValue;
    }
    
    return self;
}

@end
