//
//  DesignerListDataManager.h
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryDetailDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *diarys;
@property (nonatomic, strong) NSMutableArray *comments;

- (void)initDiary:(Diary *)diary;
- (void)refreshDiary;
- (NSInteger)refreshComment;
- (NSInteger)loadMoreComment;

@end
