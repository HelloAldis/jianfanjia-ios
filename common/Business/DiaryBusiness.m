//
//  DesignerBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiaryBusiness.h"

@implementation DiaryBusiness

+ (NSString *)diarySetInfo:(DiarySet *)diarySet {
    return [NSString stringWithFormat:@"%@m²  %@  %@  %@", diarySet.house_area, [NameDict nameForHouseType:diarySet.house_type], [NameDict nameForDecStyle:diarySet.dec_style], [NameDict nameForWorkType:diarySet.work_type]];
}

+ (BOOL)isOwnDiarySet:(DiarySet *)diarySet {
    return [diarySet.authorid isEqualToString:[GVUserDefaults standardUserDefaults].userid];
}

+ (BOOL)isOwnDiary:(Diary *)diary {
    return [diary.authorid isEqualToString:[GVUserDefaults standardUserDefaults].userid];
}

@end
