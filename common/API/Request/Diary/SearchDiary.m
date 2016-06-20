//
//  AddDiarySet.m
//  jianfanjia
//
//  Created by Karos on 16/6/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "SearchDiary.h"

@implementation SearchDiary

@dynamic query;
@dynamic from;
@dynamic limit;

- (NSDictionary *)queryConGTTime:(NSNumber *)time {
    return @{
                 @"create_at":@{
                         @"$gt":time
                 }
            };
}

- (NSDictionary *)queryConLTTime:(NSNumber *)time {
    return @{
             @"create_at":@{
                     @"$lt":time
                     }
             };
}

@end
