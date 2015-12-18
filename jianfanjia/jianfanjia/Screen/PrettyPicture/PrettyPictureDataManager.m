//
//  PrettyPictureDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PrettyPictureDataManager.h"

@implementation PrettyPictureDataManager

- (void)refreshPrettyPicture {
    NSArray* arr = [[DataManager shared].data objectForKey:@"beautiful_images"];
    NSMutableArray *prettyPictures = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        BeautifulImage *beautifulImage = [[BeautifulImage alloc] initWith:dict];
        [prettyPictures addObject:beautifulImage];
    }
    
    self.prettyPictures = prettyPictures;
}

- (void)loadMorePrettyPicture {
    NSArray* arr = [[DataManager shared].data objectForKey:@"beautiful_images"];
    NSMutableArray *prettyPictures = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        BeautifulImage *beautifulImage = [[BeautifulImage alloc] initWith:dict];
        [prettyPictures addObject:beautifulImage];
    }
    
    [self.prettyPictures addObjectsFromArray:prettyPictures];
}

@end
