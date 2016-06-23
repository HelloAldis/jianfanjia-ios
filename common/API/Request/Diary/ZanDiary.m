//
//  AddDiarySet.m
//  jianfanjia
//
//  Created by Karos on 16/6/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ZanDiary.h"

@implementation ZanDiary

@dynamic diaryid;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
