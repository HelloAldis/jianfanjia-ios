//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "CommentListDataManager.h"

@implementation CommentListDataManager

- (NSInteger)refresh {
    NSArray* arr = [[DataManager shared].data objectForKey:@"list"];
    NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        UserNotification *notification = [[UserNotification alloc] initWith:dict];
        notification.process = [[Process alloc] initWith:notification.data[@"process"]];
        notification.requirement = [[Requirement alloc] initWith:notification.data[@"requirement"]];
        notification.user = [[User alloc] initWith:notification.data[@"user"]];
        notification.designer = [[Designer alloc] initWith:notification.data[@"designer"]];
        notification.supervisor = [[Supervisor alloc] initWith:notification.data[@"supervisor"]];
        notification.plan = [[Plan alloc] initWith:notification.data[@"plan"]];
        notification.diary = [[Diary alloc] initWith:notification.data[@"diary"]];
        notification.diary.diarySet = [[DiarySet alloc] initWith:[notification.diary.data objectForKey:@"diarySet"]];
        notification.diary.author = [[Author alloc] initWith:[notification.diary.data objectForKey:@"author"]];
        [notifications addObject:notification];
    }
    
    self.comments = notifications;
    return notifications.count;
}

- (NSInteger)loadMore {
    NSArray* arr = [[DataManager shared].data objectForKey:@"list"];
    NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        UserNotification *notification = [[UserNotification alloc] initWith:dict];
        notification.process = [[Process alloc] initWith:notification.data[@"process"]];
        notification.requirement = [[Requirement alloc] initWith:notification.data[@"requirement"]];
        notification.user = [[User alloc] initWith:notification.data[@"user"]];
        notification.designer = [[Designer alloc] initWith:notification.data[@"designer"]];
        notification.supervisor = [[Supervisor alloc] initWith:notification.data[@"supervisor"]];
        notification.plan = [[Plan alloc] initWith:notification.data[@"plan"]];
        notification.diary = [[Diary alloc] initWith:notification.data[@"diary"]];
        notification.diary.diarySet = [[DiarySet alloc] initWith:[notification.diary.data objectForKey:@"diarySet"]];
        notification.diary.author = [[Author alloc] initWith:[notification.diary.data objectForKey:@"author"]];
        [notifications addObject:notification];
    }
    
    [self.comments addObjectsFromArray:notifications];
    return notifications.count;
}

@end
