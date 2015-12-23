//
//  FavoriateBeautifulImageData.m
//  jianfanjia
//
//  Created by JYZ on 15/12/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriateBeautifulImageData.h"

@implementation FavoriateBeautifulImageData

- (NSInteger)refreshBeautifulImages {
    NSArray* arr = [[DataManager shared].data objectForKey:@"beautiful_images"];
    NSMutableArray *beautifulImages = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [beautifulImages addObject:[[BeautifulImage alloc] initWith:dict]];
    }
    
    self.beautifulImages = beautifulImages;
    return [beautifulImages count];
}

- (NSInteger)loadMoreBeautifulImages {
    NSArray* arr = [[DataManager shared].data objectForKey:@"beautiful_images"];
    NSMutableArray *beautifulImages = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [beautifulImages addObject:[[BeautifulImage alloc] initWith:dict]];
    }
    
    [self.beautifulImages addObjectsFromArray:beautifulImages];
    return [beautifulImages count];
}

@end
