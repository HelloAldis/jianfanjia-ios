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
    return diarySet.house_area != nil ?[NSString stringWithFormat:@"%@m²  %@  %@  %@", diarySet.house_area, [NameDict nameForHouseType:diarySet.house_type], [NameDict nameForDecStyle:diarySet.dec_style], [NameDict nameForWorkType:diarySet.work_type]] : @"";
}

+ (BOOL)isOwnDiarySet:(DiarySet *)diarySet {
    return [diarySet.authorid isEqualToString:[GVUserDefaults standardUserDefaults].userid];
}

+ (BOOL)isOwnDiary:(Diary *)diary {
    return [diary.authorid isEqualToString:[GVUserDefaults standardUserDefaults].userid];
}

+ (BOOL)isOwnComment:(Comment *)comment {
    return [comment.user._id isEqualToString:[GVUserDefaults standardUserDefaults].userid];
}

+ (UIColor *)colorForPhase:(DiarySet *)diarySet {
    NSArray *arr = [NameDict getAllDecorationPhase];
    NSInteger index = [arr indexOfObject:diarySet.latest_section_label];
    
    if (index == arr.count - 1) {
        return kPassStatusColor;
    }
    
    return kExcutionStatusColor;
}

@end
