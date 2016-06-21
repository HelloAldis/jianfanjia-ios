//
//  Diary.m
//  jianfanjia
//
//  Created by Karos on 16/6/15.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "Diary.h"

@implementation Diary

@dynamic _id;
@dynamic authorid;
@dynamic usertype;
@dynamic diarySetid;
@dynamic content;
@dynamic section_label;
@dynamic images;
@dynamic create_at;
@dynamic lastupdate;
@dynamic view_count;
@dynamic favorite_count;
@dynamic comment_count;
@dynamic is_deleted;

- (DiaryLayout *)layout {
    if (!_layout) {
        self.layout = [[DiaryLayout alloc] init];
        _layout.diary = self;
    }
    
    return _layout;
}

- (void)updateRefreshTime {
    self.last_refresh_time = @([[NSDate date] getLongMilSecond]);
}

@end
