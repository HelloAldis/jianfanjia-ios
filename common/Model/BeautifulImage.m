//
//  BeautifulImage.m
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BeautifulImage.h"
#import "LeafImage.h"

@implementation BeautifulImage

@dynamic _id;
@dynamic create_at;
@dynamic lastupdate;
@dynamic title;
@dynamic keywords;
@dynamic beautiful_image_description;
@dynamic status;
@dynamic section;
@dynamic house_type;
@dynamic dec_style;
@dynamic dec_type;
@dynamic images;
@dynamic authorid;
@dynamic usertype;
@dynamic favorite_count;
@dynamic view_count;
@dynamic is_my_favorite;
@dynamic is_deleted;

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"beautiful_image_description" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"description"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([@"beautiful_image_description" isEqualToString:key]) {
        return [[self data] objectForKey:@"description"];
    } else {
        return [[self data] objectForKey:key];
    }
}

- (LeafImage *)leafImageAtIndex:(NSInteger )index {
    if (index >= 0 && index < self.images.count) {
        NSMutableDictionary *dict = [self.images objectAtIndex:index];
        return [[LeafImage alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end
