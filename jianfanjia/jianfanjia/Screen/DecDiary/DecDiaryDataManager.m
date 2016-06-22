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

@implementation DecDiaryDataManager

- (instancetype)init {
    if (self = [super init]) {
        _diarys = [NSMutableArray array];
    }
    
    return self;
}

- (NSInteger)refresh {
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
    return diarys.count;
}

- (NSInteger)loadMore {
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
    return diarys.count;
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
    
    [self.diarys enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Diary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (now.longLongValue - obj.last_refresh_time.longLongValue > kMinRefreshTimeInteval) {
            [dict setObject:obj forKey:obj._id];
        }
    }];
    
    return dict;
}

- (void)updateChangedDiarys:(NSMutableDictionary<NSString *, Diary *> *)toBeUpdateDict {
    NSArray* arr = [DataManager shared].data;
    for (NSMutableDictionary *dict in arr) {
        Diary *diary = [[Diary alloc] initWith:dict];
        Diary *toBeUpdateDiary = toBeUpdateDict[diary._id];
        
        toBeUpdateDiary.favorite_count = diary.favorite_count;
        toBeUpdateDiary.comment_count = diary.comment_count;
        toBeUpdateDiary.view_count = diary.view_count;
        [toBeUpdateDiary updateRefreshTime];
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
