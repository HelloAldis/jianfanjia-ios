//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "SearchBeautifulImageDataManager.h"

@implementation SearchBeautifulImageDataManager

- (NSInteger)refresh {
    NSArray* arr = [[DataManager shared].data objectForKey:@"beautiful_images"];
    NSMutableArray *beautifulImages = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        BeautifulImage *beautifulImage = [[BeautifulImage alloc] initWith:dict];
        [beautifulImages addObject:beautifulImage];
    }
    
    self.beautifulImages = beautifulImages;
    return beautifulImages.count;
}

- (NSInteger)loadMore {
    NSArray* arr = [[DataManager shared].data objectForKey:@"beautiful_images"];
    NSMutableArray *beautifulImages = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        BeautifulImage *beautifulImage = [[BeautifulImage alloc] initWith:dict];
        [beautifulImages addObject:beautifulImage];
    }
    
    [self.beautifulImages addObjectsFromArray:beautifulImages];
    return beautifulImages.count;
}

@end
