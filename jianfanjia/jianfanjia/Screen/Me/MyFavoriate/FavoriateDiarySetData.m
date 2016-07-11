//
//  FavoriateProductData.m
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriateDiarySetData.h"

@implementation FavoriateDiarySetData

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

- (NSInteger)loadMoreDiarySets {
    NSArray* arr = [[DataManager shared].data objectForKey:@"diarySets"];
    NSMutableArray *diarySets = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        DiarySet *diarySet = [[DiarySet alloc] initWith:dict];
        [diarySets addObject:diarySet];
    }
    
    [self.diarySets addObjectsFromArray:diarySets];
    return diarySets.count;
}

@end
