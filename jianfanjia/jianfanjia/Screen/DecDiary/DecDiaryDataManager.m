//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DecDiaryDataManager.h"

//刷新5分钟之外的数据
#define kMinRefreshTimeInteval 5 * 60 * 1000

@interface DecDiaryDataManager ()

@end

@implementation DecDiaryDataManager

- (instancetype)init {
    if (self = [super init]) {
        _diarys = [NSMutableArray array];
    }
    
    return self;
}

- (NSInteger)loadLatest {
    NSArray* arr = [[DataManager shared].data objectForKey:@"diaries"];
    NSMutableArray *diarys = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Diary *diary = [[Diary alloc] initWith:dict];
        DiarySet *diarySet = [[DiarySet alloc] initWith:[diary.data objectForKey:@"diarySet"]];
        Author *author = [[Author alloc] initWith:[diary.data objectForKey:@"author"]];
        diary.diarySet = diarySet;
        diary.author = author;
        [diary updateRefreshTime];
        [diarys addObject:diary];
    }
    
    [self.diarys insertObjects:diarys atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, diarys.count)]];
    [self applyTopDiarySet];
    return diarys.count;
}

- (NSInteger)loadOld {
    NSArray* arr = [[DataManager shared].data objectForKey:@"diaries"];
    NSMutableArray *diarys = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Diary *diary = [[Diary alloc] initWith:dict];
        DiarySet *diarySet = [[DiarySet alloc] initWith:[diary.data objectForKey:@"diarySet"]];
        Author *author = [[Author alloc] initWith:[diary.data objectForKey:@"author"]];
        diary.diarySet = diarySet;
        diary.author = author;
        [diary updateRefreshTime];
        [diarys addObject:diary];
    }
    
    [self.diarys addObjectsFromArray:diarys];
    [self applyTopDiarySet];
    return diarys.count;
}

- (void)loadTopDiarySets {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *diarySets = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        DiarySet *diarySet = [[DiarySet alloc] initWith:dict];
        [diarySets addObject:diarySet];
    }
    
    if (!self.topDiary) {
        self.topDiary = [[Diary alloc] init];
    }
    
    self.topDiary.topDiarySets = diarySets;
    [self applyTopDiarySet];
}

- (void)applyTopDiarySet {
    if (![self.diarys containsObject:self.topDiary]) {
        [self.diarys addObject:self.topDiary];
    }
    
    self.topDiary.create_at = @([[NSDate date] getLongMilSecond]);
    NSInteger topDiaryIndex = [self.diarys indexOfObject:self.topDiary];
    if (self.diarys.count > 2) {
        Diary *diary = self.diarys[2];
        self.topDiary.create_at = diary.create_at;
        [self.diarys exchangeObjectAtIndex:topDiaryIndex withObjectAtIndex:2];
    }
}

- (NSNumber *)findLatestCreateTimeDiary {
    if (self.diarys.count == 0) {
        return @([[NSDate date] getLongMilSecond]);
    }
    
    return [self.diarys.firstObject create_at];
}

- (NSNumber *)findOldestCreateTimeDiary {
    if (self.diarys.count == 0) {
        return @([[NSDate date] getLongMilSecond]);
    }
    
    return [self.diarys.lastObject create_at];
}

- (NSMutableDictionary<NSString *, Diary *> *)findNeedUpdatedDiarys {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSNumber *now = @([[NSDate date] getLongMilSecond]);
    
    [self.diarys enumerateObjectsUsingBlock:^(Diary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.topDiarySets && now.longLongValue - obj.last_refresh_time.longLongValue > kMinRefreshTimeInteval) {
            [dict setObject:obj forKey:obj._id];
        }
    }];
    
    return dict;
}

- (void)updateChangedDiarys:(NSMutableDictionary<NSString *, Diary *> *)toBeUpdateDict {
    NSArray* arr = [DataManager shared].data;
    for (NSMutableDictionary *dict in arr) {
        Diary *diary = [[Diary alloc] initWith:dict];
        if (dict && diary._id.length > 0) {
            Diary *toBeUpdateDiary = toBeUpdateDict[diary._id];
            
            if (!toBeUpdateDiary) {
                continue;
            }
            
            toBeUpdateDiary.favorite_count = diary.favorite_count;
            toBeUpdateDiary.comment_count = diary.comment_count;
            toBeUpdateDiary.view_count = diary.view_count;
            [toBeUpdateDiary updateRefreshTime];
        }
    }
}

- (NSInteger)refreshDiarySets {
    NSArray* arr = [[DataManager shared].data objectForKey:@"diarySets"];
    NSMutableArray *diarySets = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        DiarySet *diarySet = [[DiarySet alloc] initWith:dict];
        [diarySets addObject:diarySet];
    }
    
    self.diarySets = diarySets;
    return diarySets.count;
}

@end
