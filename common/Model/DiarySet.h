//
//  Diary.h
//  jianfanjia
//
//  Created by Karos on 16/6/15.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface DiarySet : BaseModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSString *cover_imageid;
@property (nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *work_type;
@property (nonatomic, strong) NSString *house_type;
@property (nonatomic, strong) NSString *dec_style;
@property (nonatomic, strong) NSNumber *house_area;
@property (nonatomic, strong) NSNumber *create_at;
@property (nonatomic, strong) NSNumber *lastupdate;
@property (nonatomic, strong) NSNumber *view_count;
@property (nonatomic, strong) NSNumber *favorite_count;
@property (nonatomic, strong) NSNumber *comment_count;
@property (nonatomic, strong) NSArray *diaries;

@end
