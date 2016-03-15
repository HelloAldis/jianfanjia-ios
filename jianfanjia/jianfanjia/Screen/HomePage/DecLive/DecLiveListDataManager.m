//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DecLiveListDataManager.h"

@implementation DecLiveListDataManager

- (NSInteger)refreshOngoingDeclives {
    NSMutableArray *array = nil;
    NSInteger count = [self refresh:&array];
    self.ongoingDeclives = array;
    
    return count;
}

- (NSInteger)loadMoreOngoingDeclives {
    NSMutableArray *array = self.ongoingDeclives;
    NSInteger count = [self loadMore:&array];
    self.ongoingDeclives = array;
    
    return count;
}

- (NSInteger)refreshFinishDeclives {
    NSMutableArray *array = nil;
    NSInteger count = [self refresh:&array];
    self.finishDeclives = array;
    
    return count;
}

- (NSInteger)loadMoreFinishDeclives {
    NSMutableArray *array = self.finishDeclives;
    NSInteger count = [self loadMore:&array];
    self.finishDeclives = array;
    
    return count;
}

- (NSInteger)refresh:(NSMutableArray **)array {
    NSArray* arr = [[DataManager shared].data objectForKey:@"shares"];
    NSMutableArray *declives = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        DecLive *decLive = [[DecLive alloc] initWith:dict];
        decLive.designer = [[Designer alloc] initWith:[decLive.data objectForKey:@"designer"]];
        decLive.curSection = [[DecLiveSection alloc] initWith:[[decLive.data objectForKey:@"process"] lastObject]];
        [declives addObject:decLive];
    }
    
    *array = declives;
    return declives.count;

}

- (NSInteger)loadMore:(NSMutableArray **)array {
    NSArray* arr = [[DataManager shared].data objectForKey:@"shares"];
    NSMutableArray *declives = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        DecLive *decLive = [[DecLive alloc] initWith:dict];
        decLive.designer = [[Designer alloc] initWith:[decLive.data objectForKey:@"designer"]];
        decLive.curSection = [[DecLiveSection alloc] initWith:[[decLive.data objectForKey:@"process"] lastObject]];
        [declives addObject:decLive];
    }
    
    [*array addObjectsFromArray:declives];
    return declives.count;
}

@end
