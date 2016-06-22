//
//  DesignerListDataManager.h
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecDiaryDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *diarySets;
@property (nonatomic, strong) NSMutableArray *diarys;

- (NSInteger)refresh;
- (NSInteger)loadMore;
- (NSNumber *)findLatestCreateTimeDiary;
- (NSNumber *)findOldestCreateTimeDiary;
- (NSMutableDictionary<NSString *, Diary *> *)findNeedUpdatedDiarys;
- (void)updateChangedDiarys:(NSMutableDictionary<NSString *, Diary *> *)toBeUpdateDict;
- (NSInteger)refreshDiarySets;

@end
