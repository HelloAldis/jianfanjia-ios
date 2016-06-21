//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DiaryDetailDataManager.h"

@implementation DiaryDetailDataManager

- (void)initDiary:(Diary *)diary {
    self.diarys = [@[diary] mutableCopy];
}

- (void)refreshDiary {
    Diary *fromServer = [[Diary alloc] initWith:[DataManager shared].data];
    Diary *diary = self.diarys[0];
    diary.favorite_count = fromServer.favorite_count;
    diary.view_count = fromServer.view_count;
    diary.comment_count = fromServer.comment_count;
    [diary updateRefreshTime];
}

- (NSInteger)refreshComment {
    NSArray* arr = [[DataManager shared].data objectForKey:@"comments"];
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Comment *comment = [[Comment alloc] initWith:dict];
        User *user = [[User alloc] initWith:[comment.data objectForKey:@"byUser"]];
        comment.user = user;
        [comments addObject:comment];
    }
    
    self.comments = comments;
    return comments.count;
}

- (NSInteger)loadMoreComment {
    NSArray* arr = [[DataManager shared].data objectForKey:@"comments"];
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Comment *comment = [[Comment alloc] initWith:dict];
        User *user = [[User alloc] initWith:[comment.data objectForKey:@"byUser"]];
        comment.user = user;
        [comments addObject:comment];
    }
    
    [self.comments addObjectsFromArray:comments];
    return comments.count;
}

@end
