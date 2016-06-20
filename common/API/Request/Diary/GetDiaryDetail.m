//
//  AddDiarySet.m
//  jianfanjia
//
//  Created by Karos on 16/6/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "GetDiaryDetail.h"

@implementation GetDiaryDetail

- (instancetype)initWithDiarySet:(DiarySet *)diarySet {
    if (self = [super init]) {
        self.data[@"diary_set"] = diarySet.data;
    }
    
    return self;
}

@end