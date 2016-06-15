//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DecDiaryDataManager.h"

@implementation DecDiaryDataManager

- (NSInteger)refresh {
    NSArray* arr = [[DataManager shared].data objectForKey:@"diarys"];
    NSMutableArray *diarys = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Diary *diary = [[Diary alloc] initWith:dict];
        [diarys addObject:diary];
    }
    
    self.diarys = diarys;
    return diarys.count;
}

- (NSInteger)loadMore {
    NSArray* arr = [[DataManager shared].data objectForKey:@"diarys"];
    NSMutableArray *diarys = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Diary *diary = [[Diary alloc] initWith:dict];
        [diarys addObject:diary];
    }
    
    [self.diarys addObjectsFromArray:diarys];
    return diarys.count;
}

@end
