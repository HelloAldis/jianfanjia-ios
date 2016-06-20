//
//  AddDiarySet.m
//  jianfanjia
//
//  Created by Karos on 16/6/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "GetDiaryUpdation.h"

@implementation GetDiaryUpdation

@dynamic diaryids;

- (void)handleHttpError:(NSError *)err networkError:(void (^)(void))error {
    [HUDUtil hideWait];
}

@end
