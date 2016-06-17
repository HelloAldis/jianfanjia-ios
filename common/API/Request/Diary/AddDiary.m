//
//  AddDiarySet.m
//  jianfanjia
//
//  Created by Karos on 16/6/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AddDiary.h"

@implementation AddDiary

- (instancetype)initWithDiary:(Diary *)diary {
    if (self = [super init]) {
        self.data[@"diary"] = diary.data;
    }
    
    return self;
}

@end
