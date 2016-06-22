//
//  BeautifulImage.h
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@class LeafImage;
@class BeautifulImagePosition;

@interface BeautifulImage : BaseModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSNumber *create_at;
@property (nonatomic, strong) NSNumber *lastupdate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *beautiful_image_description;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *house_type;
@property (nonatomic, strong) NSString *dec_style;
@property (nonatomic, strong) NSString *dec_type;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSNumber *favorite_count;
@property (nonatomic, strong) NSNumber *view_count;
@property (nonatomic, strong) NSNumber *is_my_favorite;
@property (nonatomic, strong) NSNumber *is_deleted;

// 不动态属性
@property (nonatomic, strong) BeautifulImagePosition *previous;
@property (nonatomic, strong) BeautifulImagePosition *next;

- (LeafImage *)leafImageAtIndex:(NSInteger )index;

@end
