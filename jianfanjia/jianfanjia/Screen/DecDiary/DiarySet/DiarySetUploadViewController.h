//
//  MeViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^DiarySetUploadDoneBlock)(void) ;

@interface DiarySetUploadViewController : BaseViewController

- (instancetype)initWithDiarySet:(DiarySet *)diarySet done:(DiarySetUploadDoneBlock)done;

@end
