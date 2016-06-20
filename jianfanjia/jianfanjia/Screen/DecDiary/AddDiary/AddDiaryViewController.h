//
//  MeViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^AddDiaryCompletion)(BOOL completion);

@interface AddDiaryViewController : BaseViewController

- (instancetype)initWithDiarySets:(NSArray<DiarySet *> *)diarySets completion:(AddDiaryCompletion)completion;

@end