//
//  Diary.h
//  jianfanjia
//
//  Created by Karos on 16/6/15.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Diary : BaseModel

@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSString *diarySetid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *section_label;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSNumber *create_at;
@property (nonatomic, strong) NSNumber *lastupdate;
@property (nonatomic, strong) NSNumber *view_count;
@property (nonatomic, strong) NSNumber *favorite_count;
@property (nonatomic, strong) NSNumber *comment_count;

//辅助属性
@property (nonatomic, assign) CGSize picSize;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) YYTextLayout *contentLayout;

@end
