//
//  PrettyPictureDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BeautifulImageDataManager.h"

@implementation BeautifulImageDataManager

- (NSInteger)refreshBeautifulImages {
    NSArray* arr = [[DataManager shared].data objectForKey:@"beautiful_images"];
    NSMutableArray *beautifulImages = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        BeautifulImage *beautifulImage = [[BeautifulImage alloc] initWith:dict];
        [beautifulImages addObject:beautifulImage];
    }
    
    self.beautifulImages = beautifulImages;
    self.total = [[[DataManager shared].data objectForKey:@"total"] integerValue];
    return beautifulImages.count;
}

- (NSInteger)loadMoreBeautifulImages {
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
