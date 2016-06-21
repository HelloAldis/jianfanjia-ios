//
//  Diary.h
//  jianfanjia
//
//  Created by Karos on 16/6/15.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@class DiaryLayout;
@class Author;

@interface Diary : BaseModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSString *diarySetid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *section_label;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSNumber *create_at;
@property (nonatomic, strong) NSNumber *lastupdate;
@property (nonatomic, strong) NSNumber *view_count;
@property (nonatomic, strong) NSNumber *favorite_count;
@property (nonatomic, strong) NSNumber *comment_count;

//辅助属性
@property (nonatomic, strong) Author *author;
@property (nonatomic, strong) DiarySet *diarySet;
@property (nonatomic, strong) DiaryLayout *layout;
@property (nonatomic, strong) NSNumber *last_refresh_time;

- (void)updateRefreshTime;

@end
