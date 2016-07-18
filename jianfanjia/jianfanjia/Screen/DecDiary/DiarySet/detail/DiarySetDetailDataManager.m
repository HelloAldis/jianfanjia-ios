//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DiarySetDetailDataManager.h"
#import "DecDiary1StatusCell.h"

@implementation DiarySetDetailDataManager

- (NSInteger)refresh {
    NSMutableDictionary *dic = [DataManager shared].data;
    self.diarySet = [[DiarySet alloc] initWith:dic];
    Author *author = [[Author alloc] initWith:[self.diarySet.data objectForKey:@"author"]];
    self.diarySet.author = author;
    
    NSArray* arr = [self.diarySet.data objectForKey:@"diaries"];
    NSMutableArray *orderedDiarys = [[NSMutableArray alloc] initWithCapacity:arr.count];
    NSMutableArray *diarys = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Diary *diary = [[Diary alloc] initWith:dict];
        diary.layout.fixHeight = DecDiary1StatusCellFixHeight;
        diary.layout.needTruncate = NO;
        [diary.layout layout];
        [diarys addObject:diary];
    }
    
    
    NSMutableArray *menuNumberOfPhases = [[NSMutableArray alloc] initWithCapacity:arr.count];
    NSArray *allKeys = [[[NameDict getAllDecorationPhase] reverseObjectEnumerator] allObjects];
    [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [menuNumberOfPhases addObject:@0];
    }];
    
    [allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        [diarys enumerateObjectsUsingBlock:^(Diary *diary, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([key isEqualToString:diary.section_label]) {
                [orderedDiarys addObject:diary];
                NSInteger index = [allKeys indexOfObject:key];
                menuNumberOfPhases[index] = @([menuNumberOfPhases[index] integerValue] + 1);
            }
        }];
    }];
    
    self.menuNumberOfPhases = menuNumberOfPhases;
    self.diarys = orderedDiarys;
    return orderedDiarys.count;
}

@end
