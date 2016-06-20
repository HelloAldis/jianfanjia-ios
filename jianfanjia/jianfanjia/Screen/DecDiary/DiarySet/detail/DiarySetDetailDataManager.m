//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DiarySetDetailDataManager.h"

@implementation DiarySetDetailDataManager

- (NSInteger)refresh {
    NSMutableDictionary *dic = [DataManager shared].data;
    self.diarySet = [[DiarySet alloc] initWith:dic];
    
    NSArray* arr = [self.diarySet.data objectForKey:@"diaries"];
    NSMutableArray *diarys = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Diary *diary = [[Diary alloc] initWith:dict];
        [diarys addObject:diary];
    }
    
    self.diarys = diarys;
    return diarys.count;
}

@end
