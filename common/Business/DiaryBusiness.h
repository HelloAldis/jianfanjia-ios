//
//  DesignerBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDiaryMessagePrefix @"回复"
#define kDiaryMessageSubfix @"："

@class DiarySet;
@class Diary;

@interface DiaryBusiness : NSObject

+ (NSString *)diarySetInfo:(DiarySet *)diarySet;
+ (BOOL)isOwnDiarySet:(DiarySet *)diarySet;
+ (BOOL)isOwnDiary:(Diary *)diary;
+ (BOOL)isOwnComment:(Comment *)comment;
+ (UIColor *)colorForPhase:(DiarySet *)diarySet;

@end
